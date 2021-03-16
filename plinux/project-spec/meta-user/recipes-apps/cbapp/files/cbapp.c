#include <assert.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h> //mmap
#include <unistd.h>
#include "cbctrl.h"

#define BRAM_BASE 0x2000000000 //address offset to Count Bits maxii (subsequently BRAM BASE)
#define BRAM_SIZE (16 * 1024)

uint32_t RegRead(void *_pHandle, uintptr_t cbOffset)
{
    cbctrl_t rd;
    cbHandle_t *pHandle = (cbHandle_t *)_pHandle;

    if (pHandle != NULL)
    {
        rd.cbOffset = cbOffset;
        ioctl(pHandle->fd, READ_REG_IOCTL, &rd);
    }

    return rd.cbData;
}

void RegWrite(void *_pHandle, uint32_t cbData, uintptr_t cbOffset)
{
    cbctrl_t wr;
    cbHandle_t *pHandle = (cbHandle_t *)_pHandle;

    if (pHandle != NULL)
    {
        wr.cbOffset = cbOffset;
        wr.cbData = cbData;
        ioctl(pHandle->fd, WRITE_REG_IOCTL, &wr);
    }
}

int main(int argc, char **argv)
{
    cbHandle_t cbHandle;
    uint32_t totalBits;
    uint32_t word_bits_regs[NUM_WORD_REGS];
    uint32_t byte_bits_regs[NUM_BYTE_REGS];
    uint32_t data[4096];
    uint32_t readdata[4096];
    uint64_t *vptr;
    uint64_t *wptr;
    uint64_t *rptr;
    int bramfd;

    printf("count bits app!\n");

    cbHandle.RegRead = RegRead;
    cbHandle.RegWrite = RegWrite;
    cbHandle.pwordRegs = word_bits_regs;
    cbHandle.pbyteRegs = byte_bits_regs;

    bramfd = open("/dev/mem", O_RDWR | O_SYNC);

    cbHandle.fd = open("/dev/cbctrl", O_RDWR | O_SYNC);
    printf("Opened device!\n");

    printf("Revision: %08X\n", cb_GetRevision(&cbHandle));
    cb_ClearRegs(&cbHandle);
    memset(data, 0, sizeof(data));
    vptr = (uint64_t *)mmap(NULL, BRAM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, bramfd, BRAM_BASE);
    wptr = vptr;
    rptr = vptr;

    for (uint64_t d = 0; d < 1024; d++)
        for (uint32_t i = 0; i < 8; i++)
            data[d] |= (d << (i * 8));

    printf("Finished data initialization\n");

    printf("Writing to BRAM\n");

    for (uint32_t wrd = 0; wrd < 1024; wrd++)
    {
        *wptr = data[wrd];
        wptr++;
    }

    printf("Reading from BRAM\n");

    for (uint32_t wrd = 0; wrd < 1024; wrd++)
    {
        readdata[wrd] = *rptr;
        rptr++;
    }

    printf("Total set bits: %d\n", cb_GetTotalBits(&cbHandle));
    for (uint32_t wreg = 0; wreg < NUM_WORD_REGS; wreg++)
    {
        printf("Word Reg %d: Bits: %d\n", wreg, cb_GetWordBitCnt(&cbHandle, wreg));
    }
    for (uint32_t breg = 0; breg < NUM_BYTE_REGS; breg++)
    {
        printf("Byte Reg %d: Bits: %d\n", breg, cb_GetByteBitCnt(&cbHandle, breg));
    }

    close(cbHandle.fd);
    close(bramfd);

    return 0;
}
