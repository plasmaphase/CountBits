#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/slab.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <linux/device.h>

#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/ioctl.h>
#include <linux/uaccess.h>
#include "cbctrl.h"

MODULE_LICENSE( "GPL" );
MODULE_AUTHOR( "Mark Gilson - www.markwgilson.com" );
MODULE_DESCRIPTION( "cbctrl - module driver for controlling countbits" );

#define DRIVER_NAME       "cbctrl"

#define cbctrl_readreg( offset )       __raw_readl(offset)
#define cbctrl_writereg( val, offset ) __raw_writel(val, offset)

static int     cbctrl_open( struct inode *ino, struct file *file );
static int     cbctrl_release( struct inode *ino, struct file *file );
static long    cbctrl_ioctl( struct file *file, unsigned int cmd, unsigned long arg );

struct cbctrl_local
{
   struct cdev   cdev;
   dev_t         dev_node;
   struct device *dev;
   void __iomem  *base_addr;
};

static struct file_operations cbctrl_fops = {
   .owner          = THIS_MODULE,
   //.write          = cbctrl_write,
   //.read           = cbctrl_read,
   .open           = cbctrl_open,
   .release        = cbctrl_release,
   .unlocked_ioctl = cbctrl_ioctl,
};
static struct class           *cbctrl_class;

/*
 * cbctrl_ioctl
 *
 * Respond to an ioctl call
 */
static long cbctrl_ioctl( struct file *file, unsigned int cmd, unsigned long arg )
{
   cbctrl_t       data;
   struct cbctrl_local *lp = file->private_data;
   int             rc, i;

   dev_dbg( lp->dev, "ioctl\n" );
   copy_from_user( &data, ( cbctrl_t * )arg, sizeof( cbctrl_t ) );
   void __iomem *offset = lp->base_addr + data.cbOffset;
   dev_info( lp->dev, "Base: %08X, ioOffset: %08X, Offset %08X\n", lp->base_addr, data.cbOffset, offset );

   switch ( cmd )
   {
      case READ_REG_IOCTL:

         dev_info( lp->dev, "READ_REG_IOCTL\n" );
         data.cbData = cbctrl_readreg( offset );
         dev_info( lp->dev, "Data: %08X\n", data.cbData);

         rc = copy_to_user( ( cbctrl_t * )arg, &data, sizeof( cbctrl_t ) );
         dev_info( lp->dev, "Copied to user\n" );
         break;
      case WRITE_REG_IOCTL:

         dev_info( lp->dev, "WRITE_REG_IOCTL\n" );

         copy_from_user( &data, ( cbctrl_t * )arg, sizeof( cbctrl_t ) );
         dev_info( lp->dev, "Data: %08X\n", data.cbData);
         cbctrl_writereg( data.cbData, offset );

         break;
      default:

         return -EINVAL;
   }

   return 0;
}

/*
 * cbctrl_open
 *
 * Open the device so that it's ready to use.
 */
static int cbctrl_open( struct inode *ino, struct file *file )
{
   struct cbctrl_local *lp;

   file->private_data = container_of( ino->i_cdev, struct cbctrl_local, cdev );

   lp = ( struct cbctrl_local * )file->private_data;

   return 0;
}

/*
 * cbctrl_release
 *
 * Release the device.
 */
static int cbctrl_release( struct inode *ino, struct file *file )
{
   struct cbctrl_local *lp = ( struct cbctrl_local * )file->private_data;

   return 0;
}

/*
 * cbctrl_cdev_init
 *
 * Initialize the driver to be a character device such that is responds to
 * file operations.
 */
static int cbctrl_cdevice_init( struct cdev   *cdev,
                            struct device *dev,
                            dev_t         *dev_node )
{
   int           rc;
   struct device *subdev;

   //Allocate a character device from the kernel for this driver
   dev_info( dev, "allocate character device cbctrl\n" );
   rc = alloc_chrdev_region( dev_node, 0, 1, "cbctrl" );

   if ( rc )
      return rc;

   //Initialize the character device data structure before registering the character device with the kernel
   dev_info( dev, "init the character device data structure\n" );
   cdev_init( cdev, &cbctrl_fops );
   cdev->owner = THIS_MODULE;
   rc          = cdev_add( cdev, *dev_node, 1 );

   if ( rc )
      goto init_error1;

   //Create the device in sysfs which will allow the device node in /dev to be created
   dev_info( dev, "create character device class\n" );
   cbctrl_class = class_create( THIS_MODULE, DRIVER_NAME );

   if ( IS_ERR( cbctrl_class ) )
      goto init_error2;

   //Create the device node in /dev so the device is accessible as a character device

   dev_info( dev, "create device node in /dev\n" );
   subdev = device_create( cbctrl_class, dev, *dev_node, NULL, "cbctrl" );

   if ( IS_ERR( subdev ) )
      goto init_error3;

   return 0;

init_error3:
   class_destroy( cbctrl_class );

init_error2:
   cdev_del( cdev );

init_error1:
   unregister_chrdev_region( *dev_node, 1 );

   return rc;
}

/*
 * cbctrl_cdevice_exit
 *
 * Exit the character device by freeing up the resources that it created and
 * disconnecting itself from the kernel.
 */
static void cbctrl_cdevice_exit( struct cdev   *cdev,
                             struct device *dev,
                             dev_t         *dev_node )
{
   //Take everything down in the reverse order from how it was created for the char device
   device_destroy( cbctrl_class, *dev_node );
   class_destroy( cbctrl_class );

   cdev_del( cdev );
   unregister_chrdev_region( *dev_node, 1 );
}

static int cbctrl_probe( struct platform_device *pdev )
{
   int             irq;
   struct resource *r_mem; /* IO mem resources */
   struct device   *dev = &pdev->dev;
   struct cbctrl_local *lp  = NULL;
   const char      *compatible;
   int             rc = 0;
   unsigned long   remap_size; /* Device Memory Size */

   dev_info( dev, "Device Tree Probing\n" );

   //Allocate the memory for the driver data, zeroing it so it's initialized and ready to use
   dev_info( dev, "Allocate memory for the driver data\n" );
   lp = ( struct cbctrl_local * )devm_kzalloc( dev, sizeof( struct cbctrl_local ), GFP_KERNEL );

   if ( !lp )
      return -ENOMEM;

   //Connect the device to the driver data and the driver data to the device so that the all data is easily accessible
   dev_info( dev, "Connect the device to the driver data\n" );
   dev_set_drvdata( dev, lp );
   lp->dev = dev;

   //Setup the memory to allow the device to be accessed, this includes
   //getting the memory info from the device tree and mapping the physical memory
   //into the virtual address space
   dev_info( dev, "Setup memory to allow the device to be accessed\n" );
   r_mem         = platform_get_resource( pdev, IORESOURCE_MEM, 0 );
   lp->base_addr = devm_ioremap_resource( dev, r_mem );
   remap_size    = r_mem->end - r_mem->start + 1; // get resource memory size
   dev_info( dev, "Remapped resource size: %lu  Start: %lu\n", remap_size, ( unsigned long )r_mem->start );

   if ( IS_ERR( lp->base_addr ) )
   {
      printk( KERN_ERR "devm_ioremap failed for cbctrl\n" );

      return PTR_ERR( lp->base_addr );
   }

   dev_info( dev, "Device Base Addr: %08x\n", lp->base_addr );

   //Setup the interrupt for the device, this includes getting the interrupt data from the device tree and then
   //requesting that interrupt from the kernel

   //irq = platform_get_irq( pdev, 0 );
   //rc  = devm_request_irq( dev, irq, &cbctrl_irq, 0, DRIVER_NAME, lp );

   if ( rc )
   {
      dev_err( dev, "Could not allocate interrupt\n" );

      return rc;
   }

   dev_info( dev, "Read Compatible string for verification\n" );
   rc = of_property_read_string( dev->of_node, "compatible", &compatible );

   if ( !rc )
   {
      char temp[128];
      sprintf( temp, "device tree compatible property = %s", compatible );
      dev_info( dev, temp );
   }

   //Initalize the device to make it a character device so that it can be accessed using char mode read/write functions
   dev_info( dev, "device init\n" );
   rc = cbctrl_cdevice_init( &lp->cdev, dev, &lp->dev_node );

   if ( rc )
      dev_info( dev, "driver wasn't able to be initialized!\n" );

   dev_info( dev, "cbctrl module driver initialized!\n" );

   return 0;
}

static int cbctrl_remove( struct platform_device *pdev )
{
   struct device   *dev = &pdev->dev;
   struct cbctrl_local *lp  = dev_get_drvdata( dev );

   cbctrl_cdevice_exit( &lp->cdev, dev, &lp->dev_node );
   dev_set_drvdata( dev, NULL );

   return 0;
}

static struct of_device_id cbctrl_of_match[] = {
   {
      .compatible = "xlnx,CountBits-1.0",
   },
   { /* end of list */ },
};
MODULE_DEVICE_TABLE( of, cbctrl_of_match );

static struct platform_driver cbctrl_driver = {
   .driver            = {
      .name           = DRIVER_NAME,
      .owner          = THIS_MODULE,
      .of_match_table = cbctrl_of_match,
   },
   .probe  = cbctrl_probe,
   .remove = cbctrl_remove,
};

static int __init cbctrl_init( void )
{
   printk( "Initialization of cbctrl module.\n" );

   return platform_driver_register( &cbctrl_driver );
}

static void __exit cbctrl_exit( void )
{
   platform_driver_unregister( &cbctrl_driver );
   printk( KERN_ALERT "Uninitialization of cbctrl module.\n" );
}

module_init( cbctrl_init );
module_exit( cbctrl_exit );
