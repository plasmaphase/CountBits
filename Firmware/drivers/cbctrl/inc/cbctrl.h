// ---------------------------------------------------------------------------------------------------------------------------
///
/// \addtogroup        cbctrl
///
/// \brief             Count Bits Control
///
/// \details           This header provides structures and information to properly interact with the count bits block
//
// ---------------------------------------------------------------------------------------------------------------------------
#ifndef CBCTRL_H
#define CBCTRL_H

#include <stdbool.h>
#include <stddef.h>
#include <linux/ioctl.h>
#include <linux/types.h>

#define BITS_PER_BYTE 8
#define REG_BYTE_WIDTH 4
#define REG_BIT_WIDTH (REG_BYTE_WIDTH * BITS_PER_BYTE)

#define READ_T 0
#define WRITE_T 1

/**
 * @brief This is a common structure shared by the app side
 * to transfer data (@offset) in or out of kernel
 * 
 */
typedef struct cbctrl_t
{
    uint32_t cbData;
    uintptr_t cbOffset;
} cbctrl_t;

#if defined(PETALINUX)
#define READ_REG_IOCTL _IOR(SCULL_IOC_MAGIC, 1, cbctrl_t *)
#define WRITE_REG_IOCTL _IOW(SCULL_IOC_MAGIC, 2, cbctrl_t *)
#define SCULL_IOC_MAGIC 'e'
#endif

typedef uint32_t (*cbctrl_RegRead)(void *_pHandle, uintptr_t cbOffset);
typedef void (*cbctrl_RegWrite)(void *_pHandle, uint32_t cbData, uintptr_t cbOffset);

typedef struct cbHandle_t
{
    cbctrl_RegRead RegRead;   //function pointer to register read
    cbctrl_RegWrite RegWrite; //function pointer to register write
    int fd;                   //only needed for linux app
    uintptr_t baseAddr;
} cbHandle_t;

#endif // CBCTRL_H
