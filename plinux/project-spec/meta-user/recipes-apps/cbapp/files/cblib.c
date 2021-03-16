/*******************************************************************
 * \file   cblib.c
 * \brief  This driver is a set of functions 
 *
 * \author 509033
 * \date   November 2020
 *********************************************************************/

#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "cbctrl.h"

#define REVISION_OFFSET (0 * REG_BYTE_WIDTH)
#define CONTROL_OFFSET (1 * REG_BYTE_WIDTH)
#define TOTAL_BITS_OFFSET (2 * REG_BYTE_WIDTH)
#define WORD_BITS_OFFSET (3 * REG_BYTE_WIDTH)
#define BYTE_BITS_OFFSET ((WORD_BITS_OFFSET + NUM_WORD_REGS + 1) * REG_BYTE_WIDTH)

/**
 * @brief bit definitions for the control register in count bits
 * 
 */
typedef struct control_reg_t
{
   uint32_t clear_regs : 1;
   uint32_t : 0;
} control_reg_t;

typedef union control_reg_u
{
   control_reg_t ctrl;
   uint32_t data;
} control_reg_u;


/**
 * @brief structure defining register layout of count bits
 * 
 */
typedef struct cb_regs_t
{
   uint32_t revision;
   control_reg_t control;
   uint32_t total_bits_reg;
   uint32_t word_bits_regs[NUM_WORD_REGS];
   uint32_t byte_bits_regs[NUM_BYTE_REGS];
} cb_regs_t;

uint32_t cb_GetRevision(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   uint32_t RetVal = 0;

   if (pHandle != NULL)
   {
      RetVal = pHandle->RegRead(pHandle, (uintptr_t)REVISION_OFFSET);
   }

   return RetVal;
}

uint32_t cb_GetControl(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   uint32_t RetVal = 0;

   if (pHandle != NULL)
   {
      RetVal = pHandle->RegRead(pHandle, (uintptr_t)CONTROL_OFFSET);
   }

   return RetVal;
}

void cb_ClearRegs(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   control_reg_u ctrlreg;

   if (pHandle != NULL)
   {
      ctrlreg.ctrl.clear_regs = 1;
      pHandle->RegWrite(pHandle, ctrlreg.data, (uintptr_t)CONTROL_OFFSET);
      ctrlreg.ctrl.clear_regs = 0;
      pHandle->RegWrite(pHandle, ctrlreg.data, (uintptr_t)CONTROL_OFFSET);
   }
}

uint32_t cb_GetTotalBits(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   uint32_t totalbits = 0;

   if (pHandle != NULL)
   {
      totalbits = pHandle->RegRead(pHandle, (uintptr_t)TOTAL_BITS_OFFSET);
   }

   return totalbits;
}

uint32_t cb_GetWordBitCnt(void *_pHandle, uint32_t idx)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   uint32_t WordBits;

   if (pHandle != NULL)
   {
      WordBits = pHandle->RegRead(pHandle, (uintptr_t)(WORD_BITS_OFFSET + (idx * REG_BYTE_WIDTH)));
   }
}

void cb_GetWordBits(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;

   if (pHandle != NULL)
   {
      for (uint8_t w = 0; w < NUM_WORD_REGS; w++)
         pHandle->pwordRegs[w] = pHandle->RegRead(pHandle, (uintptr_t)(WORD_BITS_OFFSET + (w * REG_BYTE_WIDTH)));
   }
}

uint32_t cb_GetByteBitCnt(void *_pHandle, uint32_t idx)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;
   uint32_t WordBits;

   if (pHandle != NULL)
   {
      WordBits = pHandle->RegRead(pHandle, (uintptr_t)(BYTE_BITS_OFFSET + (idx * REG_BYTE_WIDTH)));
   }
}

void cb_GetByteBits(void *_pHandle)
{
   cbHandle_t *pHandle = (cbHandle_t *)_pHandle;

   if (pHandle != NULL)
   {
      for (uint8_t b = 0; b < NUM_BYTE_REGS; b++)
         pHandle->pbyteRegs[b] = pHandle->RegRead(pHandle, (uintptr_t)(BYTE_BITS_OFFSET + (b * REG_BYTE_WIDTH)));
   }
}
