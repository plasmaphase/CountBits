#include <assert.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h> //mmap
#include <unistd.h>
#include "cblib.h"

#define BRAM_BASE 0x2000000000
#define BRAM_SIZE                 0x8000

uint32_t seedlist[MAX_NUM_SEEDS] = {
   602789438, 519518325, 751439437, 877347785, 60257934,  907015209, 764974850, 639883463, 712803941, 477771216, 861939558, 949623268, 476210277, 990080890, 985933003, 370904729, 901570591, 60143437,
   768692634, 419121460, 68822473,  247575078, 949820384, 69423064,  396493856, 443130258, 13079893,  434744491, 236681,    103856023, 787291387, 919066814, 403572473, 907786178, 860600868, 643026062,
   225782902, 219471175, 782457923, 27313109,  604914228, 971626687, 170838510, 199712501, 477929097, 149246040, 22306008,  90514446,  527892779, 249088251, 75023374,  527603349, 929484186, 972545335,
   4393468,   353061276, 726710306, 374228567, 640969427, 369879442, 405580594, 345256136, 33799555,  910993902
};

uint32_t RegRead( void *_pHandle, uintptr_t eiOffset )
{
   ei_rdwr_t  rd;
   eiHandle_t *pHandle = ( eiHandle_t * )_pHandle;

   if ( pHandle != NULL )
   {
      rd.eiOffset = eiOffset;
      ioctl( pHandle->fd, READ_REG_IOCTL, &rd );
   }

   return rd.eiData;
}

void RegWrite( void *_pHandle, uint32_t eiData, uintptr_t eiOffset )
{
   ei_rdwr_t  wr;
   eiHandle_t *pHandle = ( eiHandle_t * )_pHandle;

   if ( pHandle != NULL )
   {
      wr.eiOffset = eiOffset;
      wr.eiData   = eiData;
      ioctl( pHandle->fd, WRITE_REG_IOCTL, &wr );
   }
}

int main( int argc, char **argv )
{
   eiHandle_t eiHandle;
   uint32_t   wrthresholds[MAX_BIT_ERR_PER_BUS];
   uint32_t   rdthresholds[MAX_BIT_ERR_PER_BUS];
   uint32_t   rdseeds[MAX_NUM_SEEDS];
   uint64_t   data[4096];
   uint64_t   readdata[4096];
   uint32_t   datamask[MAX_AXI_DATA_WIDTH / REG_BIT_WIDTH];
   uint64_t   rdAddrMask;
   uint64_t   rdAddr;
   uint32_t   rddatamask[MAX_AXI_DATA_WIDTH / REG_BIT_WIDTH];
   uint64_t   *vptr;
   uint64_t   *wptr;
   uint64_t   *rptr;
   int        bramfd;

   printf( "error injector Library!\n" );

   eiHandle.RegRead         = RegRead;
   eiHandle.RegWrite        = RegWrite;
   eiHandle.seeds           = seedlist;
   eiHandle.NumSeeds        = MAX_NUM_SEEDS;
   eiHandle.wrThresholds    = wrthresholds;
   eiHandle.NumWrThresholds = MAX_BIT_ERR_PER_BUS;
   eiHandle.rdThresholds    = wrthresholds;
   eiHandle.NumRdThresholds = MAX_BIT_ERR_PER_BUS;

   bramfd = open("/dev/mem", O_RDWR | O_SYNC);

   eiHandle.fd = open( "/dev/eiregs", O_RDWR | O_SYNC );
   printf( "Opened device!\n" );

   printf( "Revision: %08X\n", ei_GetRevision( &eiHandle ) );
   printf( "Data Bus Width %d\n", ei_GetDataBusWidth( &eiHandle ) );
   printf( "Address Bus Width %d\n", ei_GetAddrBusWidth( &eiHandle ) );
   printf( "Bit Errors Allowed per Bus %d\n", ei_GetBitErrPerBus( &eiHandle ) );
   ei_SetSeeds( &eiHandle );
   eiHandle.seeds = rdseeds;
   ei_GetSeeds( &eiHandle );
   eiHandle.seeds = seedlist;

   for ( uint32_t seed = 0; seed < MAX_NUM_SEEDS; seed++ )
   {
      assert( rdseeds[seed] == seedlist[seed] );
      //printf( "Seed #%d  Wr: %08X  Rd %08X\r\n", seed, seedlist[seed], rdseeds[seed] );
   }

   ei_EnableLFSRs( &eiHandle );
   printf( "LFSR Mask: %" PRIx64 "\r\n", ei_GetLFSREn( &eiHandle ) );

   for ( uint32_t b = 0; b < ei_GetDataBusWidth( &eiHandle ) / REG_BIT_WIDTH; b++ )
      datamask[b] = UINT32_MAX;

   ei_SetMasks( &eiHandle, READ_T, 1, 1, datamask, ei_GetAddrBusWidth( &eiHandle ) / REG_BIT_WIDTH );
   //ei_SetMasks( WRITE_T, 1, 1, datamask, MAX_AXI_DATA_WIDTH / REG_BIT_WIDTH );
   ei_GetMasks( &eiHandle, READ_T, &rdAddrMask, &rdAddr, rddatamask, ei_GetAddrBusWidth( &eiHandle ) / REG_BIT_WIDTH );
   printf( "Addr Mask: %" PRIx64 ", Addr: %" PRIx64 ", Data Mask: ", rdAddrMask, rdAddr );

   for ( uint32_t i = 0; i < ei_GetDataBusWidth( &eiHandle ) / REG_BIT_WIDTH; i++ )
      printf( "%08X ", rddatamask[i] );

   printf( "\r\n\r\n" );

   ei_SetMode( &eiHandle, READ_T, true, false );
   ei_ReadEn( &eiHandle );

   memset( data, 0, sizeof( data ) );
   vptr = ( uint64_t * )mmap( NULL, BRAM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, bramfd, BRAM_BASE );
   wptr = vptr;
   rptr = vptr;

   for ( uint64_t d = 0; d < 1024; d++ )
      for ( uint32_t i = 0; i < 8; i++ )
         data[d] |= ( d << ( i * 8 ) );

   printf( "Finished data initialization\n" );

   printf( "Writing to BRAM\n" );

   for ( uint32_t wrd = 0; wrd < 1024; wrd++ )
   {
      *wptr = data[wrd];
      wptr++;
   }

   printf( "Reading from BRAM\n" );

   for ( uint32_t wrd = 0; wrd < 1024; wrd++ )
   {
      readdata[wrd] = *rptr;
      rptr++;
   }

   for ( uint32_t i = 0; i < 1024; i++ )
   {
      printf( "D: %"  PRIx64 "\r\n", readdata[i] );
      //xil_printf( "D: %08X\r\n", readdata[i] );
   }

   close( eiHandle.fd );
   close(bramfd);

   return 0;
}
