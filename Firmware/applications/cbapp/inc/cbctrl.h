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
#define AXI_DATA_WIDTH 512
#define NUM_WORD_REGS (AXI_DATA_WIDTH / 32)
#define NUM_BYTE_REGS (AXI_DATA_WIDTH / 8)

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

/**
 * @brief Function pointer used for reading registers
 * 
 */
typedef uint32_t (*cbctrl_RegRead)(void *_pHandle, uintptr_t cbOffset);
/**
 * @brief Function pointer used for writing registers
 * 
 */
typedef void (*cbctrl_RegWrite)(void *_pHandle, uint32_t cbData, uintptr_t cbOffset);

/**
 * @brief count bits handle containing data related to count bits
 * 
 */
typedef struct cbHandle_t
{
    cbctrl_RegRead RegRead;   //function pointer to register read
    cbctrl_RegWrite RegWrite; //function pointer to register write
    int fd;                   //only needed for linux app
    uintptr_t baseAddr;
    void *pwordRegs;
    void *pbyteRegs;
} cbHandle_t;

/**
 * @brief Get current revision of count bits
 * 
 * @param _pHandle pointer to cbHandle
 * @return uint32_t revision
 */
uint32_t cb_GetRevision(void *_pHandle);

/**
 * @brief Get control register of count bits
 * 
 * @param _pHandle pointer to cbHandle
 * @return uint32_t 32-bit populated control register
 */
uint32_t cb_GetControl(void *_pHandle);

/**
 * @brief Clear all count bits registers (total, word, and byte)
 * 
 * @param _pHandle pointer to cbHandle
 */
void cb_ClearRegs(void *_pHandle);

/**
 * @brief Get value of total bits accumulated set bits register
 * 
 * @param _pHandle pointer to cbHandle
 * @return uint32_t total set bits accumulated
 */
uint32_t cb_GetTotalBits(void *_pHandle);

/**
 * @brief Get accumulated set bits for specific word register
 * 
 * @param _pHandle pointer to cbHandle
 * @param idx word bits register offset/index
 * @return uint32_t total word bits accumulated
 */
uint32_t cb_GetWordBitCnt(void *_pHandle, uint32_t idx);

/**
 * @brief Retrieve all word bits registers
 *        Populates _pHandle->pwordRegs
 * 
 * @param _pHandle pointer to cbHandle
 */
void cb_GetWordBits(void *_pHandle);

/**
 * @brief Get accumulated set bits for specific byte register
 * 
 * @param _pHandle pointer to cbHandle
 * @param idx byte bits register offset/index
 * @return uint32_t total byte bits accumulated
 */
uint32_t cb_GetByteBitCnt(void *_pHandle, uint32_t idx);

/**
 * @brief Retrieve all byte bits registers
 *        Populates _pHandle->pbyteRegs
 * 
 * @param _pHandle pointer to cbHandle
 */
void cb_GetByteBits(void *_pHandle);

#endif // CBCTRL_H
