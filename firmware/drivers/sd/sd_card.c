#include "sd.h"

#ifdef INCLUDE_SD_CARD_DRIVER
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include "timer.h"
#include "assert.h"
#include "csr.h"

#ifndef SD_CTRL_BASE
    #define SD_CTRL_BASE 0x95000000
#endif

#define SD_BUFFER_SIZE (65536 / 512)
//#define SD_BUFFER_SIZE (8192 / 512)

#ifdef CONFIG_SD_CARD_MINIMAL
#define dprintf
#else
#define dprintf printf
#endif

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
#define SD_CONTROL        0x0
    #define SD_CONTROL_START                     31
    #define SD_CONTROL_START_SHIFT               31
    #define SD_CONTROL_START_MASK                0x1

    #define SD_CONTROL_ABORT                     30
    #define SD_CONTROL_ABORT_SHIFT               30
    #define SD_CONTROL_ABORT_MASK                0x1

    #define SD_CONTROL_FIFO_RST                  29
    #define SD_CONTROL_FIFO_RST_SHIFT            29
    #define SD_CONTROL_FIFO_RST_MASK             0x1

    #define SD_CONTROL_BLOCK_CNT_SHIFT           8
    #define SD_CONTROL_BLOCK_CNT_MASK            0xff

    #define SD_CONTROL_WRITE                     5
    #define SD_CONTROL_WRITE_SHIFT               5
    #define SD_CONTROL_WRITE_MASK                0x1

    #define SD_CONTROL_DMA_EN                    4
    #define SD_CONTROL_DMA_EN_SHIFT              4
    #define SD_CONTROL_DMA_EN_MASK               0x1

    #define SD_CONTROL_WIDE_MODE                 3
    #define SD_CONTROL_WIDE_MODE_SHIFT           3
    #define SD_CONTROL_WIDE_MODE_MASK            0x1

    #define SD_CONTROL_DATA_EXP                  2
    #define SD_CONTROL_DATA_EXP_SHIFT            2
    #define SD_CONTROL_DATA_EXP_MASK             0x1

    #define SD_CONTROL_RESP136_EXP               1
    #define SD_CONTROL_RESP136_EXP_SHIFT         1
    #define SD_CONTROL_RESP136_EXP_MASK          0x1

    #define SD_CONTROL_RESP48_EXP                0
    #define SD_CONTROL_RESP48_EXP_SHIFT          0
    #define SD_CONTROL_RESP48_EXP_MASK           0x1

#define SD_CLOCK          0x4
    #define SD_CLOCK_DIV_SHIFT                   0
    #define SD_CLOCK_DIV_MASK                    0xff

#define SD_STATUS         0x8
    #define SD_STATUS_CMD_IN                     8
    #define SD_STATUS_CMD_IN_SHIFT               8
    #define SD_STATUS_CMD_IN_MASK                0x1

    #define SD_STATUS_DAT_IN_SHIFT               4
    #define SD_STATUS_DAT_IN_MASK                0xf

    #define SD_STATUS_FIFO_EMPTY                 3
    #define SD_STATUS_FIFO_EMPTY_SHIFT           3
    #define SD_STATUS_FIFO_EMPTY_MASK            0x1

    #define SD_STATUS_FIFO_FULL                  2
    #define SD_STATUS_FIFO_FULL_SHIFT            2
    #define SD_STATUS_FIFO_FULL_MASK             0x1

    #define SD_STATUS_CRC_ERR                    1
    #define SD_STATUS_CRC_ERR_SHIFT              1
    #define SD_STATUS_CRC_ERR_MASK               0x1

    #define SD_STATUS_BUSY                       0
    #define SD_STATUS_BUSY_SHIFT                 0
    #define SD_STATUS_BUSY_MASK                  0x1

#define SD_CMD0           0xc
    #define SD_CMD0_VALUE_SHIFT                  0
    #define SD_CMD0_VALUE_MASK                   0xffffffff

#define SD_CMD1           0x10
    #define SD_CMD1_VALUE_SHIFT                  0
    #define SD_CMD1_VALUE_MASK                   0xffff

#define SD_RESP0          0x14
    #define SD_RESP0_VALUE_SHIFT                 0
    #define SD_RESP0_VALUE_MASK                  0xffffffff

#define SD_RESP1          0x18
    #define SD_RESP1_VALUE_SHIFT                 0
    #define SD_RESP1_VALUE_MASK                  0xffffffff

#define SD_RESP2          0x1c
    #define SD_RESP2_VALUE_SHIFT                 0
    #define SD_RESP2_VALUE_MASK                  0xffffffff

#define SD_RESP3          0x20
    #define SD_RESP3_VALUE_SHIFT                 0
    #define SD_RESP3_VALUE_MASK                  0xffffffff

#define SD_RESP4          0x24
    #define SD_RESP4_VALUE_SHIFT                 0
    #define SD_RESP4_VALUE_MASK                  0xffffffff

#define SD_TX             0x28
    #define SD_TX_DATA_SHIFT                     0
    #define SD_TX_DATA_MASK                      0xffffffff

#define SD_RX             0x2c
    #define SD_RX_DATA_SHIFT                     0
    #define SD_RX_DATA_MASK                      0xffffffff

#define SD_DMA            0x30
    #define SD_DMA_ADDR_SHIFT                    0
    #define SD_DMA_ADDR_MASK                     0xffffffff

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
#define CMD0_GO_IDLE_STATE              0
#define CMD1_SEND_OP_COND               1
#define CMD8_SEND_IF_COND               8
#define CMD17_READ_SINGLE_BLOCK         17
#define CMD18_READ_MULTIPLE_BLOCK       18
#define CMD24_WRITE_SINGLE_BLOCK        24
#define CMD32_ERASE_WR_BLK_START        32
#define CMD33_ERASE_WR_BLK_END          33
#define CMD38_ERASE                     38
#define ACMD41_SD_SEND_OP_COND          41
#define CMD55_APP_CMD                   55
#define CMD58_READ_OCR                  58

#define CMD_START_BITS                  0x40
#define CMD0_CRC                        0x95
#define CMD8_CRC                        0x87

#define OCR_SHDC_FLAG                   0x40
#define CMD_OK                          0x01

#define CMD8_3V3_MODE_ARG               0x1AA

#define ACMD41_HOST_SUPPORTS_SDHC       0x40000000

#define CMD_START_OF_BLOCK              0xFE
#define CMD_DATA_ACCEPTED               0x05

/* Card Status Response (R1) */
#define SDMC_R1_AKE_SEQ_ERROR       0x00000008  /* Authentication Error     */
#define SDMC_R1_APP_CMD         0x00000020  /* Next command is application  */
#define SDMC_R1_READY_FOR_DATA      0x00000100  /* Card ready for data      */
#define SDMC_R1_CURRENT_STATE       0x00001E00  /* Current card state       */
#define SDMC_R1_ERASE_RESET     0x00002000  /* Erase processes reset    */
#define SDMC_R1_CARD_ECC_DISABLED   0x00004000  /* Command without ECC      */
#define SDMC_R1_WP_ERASE_SKIP       0x00008000  /* Write protected      */
#define SDMC_R1_CSD_OVERWRITE       0x00010000  /* Error in CSD overwrite   */
#define SDMC_R1_ERROR           0x00080000  /* Unknown error        */
#define SDMC_R1_CC_ERROR        0x00100000  /* Internal controller error    */
#define SDMC_R1_CARD_ECC_FAILED     0x00200000  /* ECC correction failed    */
#define SDMC_R1_ILLEGAL_COMMAND     0x00400000  /* Not a legal command      */
#define SDMC_R1_COM_CRC_ERROR       0x00800000  /* Previous command CRC failed  */
#define SDMC_R1_LOCK_UNLOCK_FAILED  0x01000000  /* Lock/unlock of card failed   */
#define SDMC_R1_CARD_IS_LOCKED      0x02000000  /* Card is locked       */
#define SDMC_R1_WP_VIOLATION        0x04000000  /* Write to protected block */
#define SDMC_R1_ERASE_PARAM     0x08000000  /* Invalid erase parameter  */
#define SDMC_R1_ERASE_SEQ_ERROR     0x10000000  /* Invalid erase sequence   */
#define SDMC_R1_BLOCK_LEN_ERROR     0x20000000  /* TX block length not allowed  */
#define SDMC_R1_ADDRESS_ERROR       0x40000000  /* Misaligned address       */
#define SDMC_R1_OUT_OF_RANGE        0x80000000  /* Argument out of range    */

/* Card state */
#define SDMC_R1_IDLE_STATE      0x00000000  /* Idle State           */
#define SDMC_R1_READY_STATE     0x00000200  /* Ready State          */
#define SDMC_R1_IDENT_STATE     0x00000400  /* Identification State     */
#define SMDC_R1_STBY_STATE      0x00000600  /* Standby State        */
#define SDMC_R1_TRAN_STATE      0x00000800  /* Transfer State       */
#define SDMC_R1_DATA_STATE      0x00000A00  /* Sending-data State       */
#define SDMC_R1_RCV_STATE       0x00000C00  /* Receive-data State       */
#define SDMC_R1_PRG_STATE       0x00000E00  /* Programming State        */
#define SMDC_R1_DIS_STATE       0x00001000  /* Disconnect State     */

/* Published RCA Response (R6) */
#define SDMC_R6_RCA_MASK        0xFFFF0000  /* Relative card address mask   */
#define SDMC_R6_AKE_SEQ_ERROR       0x00000008  /* Authentication Error     */
#define SDMC_R6_APP_CMD         0x00000020  /* Next command is application  */
#define SDMC_R6_READY_FOR_DATA      0x00000100  /* Card ready for data      */
#define SDMC_R6_CURRENT_STATE       0x00001E00  /* Current card state       */
#define SDMC_R6_ERROR           0x00002000  /* Unknown error        */
#define SDMC_R6_ILLEGAL_COMMAND     0x00004000  /* Not a legal command      */
#define SDMC_R6_COM_CRC_ERROR       0x00008000  /* Previous command CRC failed  */

//-----------------------------------------------------------------
// Locals
//-----------------------------------------------------------------
static int _sdhc_card = 0;
static int _wide_mode = 0;

//-----------------------------------------------------------------
// Register Access
//-----------------------------------------------------------------
static inline void REG_WRITE(uint32_t addr, uint32_t value)
{
    volatile uint32_t * cfg = (volatile uint32_t * )SD_CTRL_BASE;
    cfg[addr/4] = value;
}
static inline uint32_t REG_READ(uint32_t addr)
{
    volatile uint32_t * cfg = (volatile uint32_t * )SD_CTRL_BASE;
    return cfg[addr/4];
}

//-----------------------------------------------------------------
// sd_send_cmd: Send command (R1/R3/R6/R7 response expected)
//-----------------------------------------------------------------
static bool sd_send_cmd(uint32_t cmd, uint32_t arg, uint32_t *resp)
{
    uint32_t ctrl  = 0;
    uint64_t value = 0;

    value |= ((uint64_t)1   << 46); // Transmission bit
    value |= ((uint64_t)cmd << 40); // Command index
    value |= ((uint64_t)arg << 8);  // Argument

    REG_WRITE(SD_CMD0, value >> 16);
    REG_WRITE(SD_CMD1, value >> 0);

    ctrl = (1 << SD_CONTROL_START_SHIFT) | ((resp != NULL) << SD_CONTROL_RESP48_EXP_SHIFT);

    if ((cmd == CMD17_READ_SINGLE_BLOCK) || (cmd == CMD18_READ_MULTIPLE_BLOCK))
        ctrl |= (1 << SD_CONTROL_DATA_EXP_SHIFT);

    if (((cmd == CMD17_READ_SINGLE_BLOCK) || (cmd == CMD18_READ_MULTIPLE_BLOCK) || (cmd == CMD24_WRITE_SINGLE_BLOCK)) && _wide_mode)
        ctrl |= (1 << SD_CONTROL_WIDE_MODE_SHIFT);

    if (cmd == CMD18_READ_MULTIPLE_BLOCK)
        ctrl |= ((SD_BUFFER_SIZE-1) << SD_CONTROL_BLOCK_CNT_SHIFT);

    if (cmd == CMD24_WRITE_SINGLE_BLOCK)
        ctrl |= (1 << SD_CONTROL_WRITE_SHIFT);

    REG_WRITE(SD_CONTROL, ctrl);

    t_time ts = timer_now();
    while (REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT))
    {
        // Timeout
        if (timer_diff(timer_now(), ts) > 250)
        {
            REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
            return false;
        }
    }

    if (resp)
    {
        uint32_t resp_data = REG_READ(SD_RESP0) >> 8;
        resp_data |= (REG_READ(SD_RESP1) << 24);
        *resp = resp_data;
    }

    return true;
}
//-----------------------------------------------------------------
// sd_send_cmd: Send command - wait for response
//-----------------------------------------------------------------
static bool sd_send_cmd_r2(uint32_t cmd, uint32_t arg, uint32_t *resp)
{
    uint64_t value = 0;

    value |= ((uint64_t)1   << 46); // Transmission bit
    value |= ((uint64_t)cmd << 40); // Command index
    value |= ((uint64_t)arg << 8);  // Argument

    REG_WRITE(SD_CMD0, value >> 16);
    REG_WRITE(SD_CMD1, value >> 0);

    REG_WRITE(SD_CONTROL, (1 << SD_CONTROL_START_SHIFT) | ((resp != NULL) << SD_CONTROL_RESP136_EXP_SHIFT));

    t_time ts = timer_now();
    while (REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT))
    {
        // Timeout
        if (timer_diff(timer_now(), ts) > 250)
        {
            REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
            return false;
        }
    }

    if (resp)
    {
        resp[0] = REG_READ(SD_RESP0);
        resp[1] = REG_READ(SD_RESP1);
        resp[2] = REG_READ(SD_RESP2);
        resp[3] = REG_READ(SD_RESP3);
        resp[4] = REG_READ(SD_RESP4);
    }

    return true;
}
//-----------------------------------------------------------------
// sd_send_cmd_data: Read or write data
//-----------------------------------------------------------------
static bool sd_send_cmd_data(uint32_t cmd, uint32_t arg, uint32_t *resp, uint32_t blocks, uint8_t *target, bool dma)
{
    uint32_t ctrl  = 0;
    uint64_t value = 0;    

    assert(!(((uint32_t)target) & 3));

    value |= ((uint64_t)1   << 46); // Transmission bit
    value |= ((uint64_t)cmd << 40); // Command index
    value |= ((uint64_t)arg << 8);  // Argument

    REG_WRITE(SD_CMD0, value >> 16);
    REG_WRITE(SD_CMD1, value >> 0);

    ctrl = (1 << SD_CONTROL_START_SHIFT) | ((resp != NULL) << SD_CONTROL_RESP48_EXP_SHIFT);
    ctrl |= (1 << SD_CONTROL_DATA_EXP_SHIFT);
    if (_wide_mode)
        ctrl |= (1 << SD_CONTROL_WIDE_MODE_SHIFT);

    ctrl |= ((blocks-1) << SD_CONTROL_BLOCK_CNT_SHIFT);

    if (dma)
    {        
        REG_WRITE(SD_DMA, ((uint32_t)target));
        ctrl |= (1 << SD_CONTROL_DMA_EN_SHIFT);
    }

    REG_WRITE(SD_CONTROL, ctrl);

    t_time ts = timer_now();
    while (REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT))
    {
        // Timeout
        if (timer_diff(timer_now(), ts) > 1000)
        {
            REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
            return false;
        }
    }

    if (resp)
    {
        uint32_t resp_data = REG_READ(SD_RESP0) >> 8;
        resp_data |= (REG_READ(SD_RESP1) << 24);
        *resp = resp_data;
    }

    if (!dma)
    {
        uint32_t *p = (uint32_t*)target;
        while (!(REG_READ(SD_STATUS) & (1 << SD_STATUS_FIFO_EMPTY_SHIFT)))
        {
            uint32_t v = REG_READ(SD_RX);
            *p++ = v;
        }
    }

    return true;
}
//-----------------------------------------------------------------
// sd_init: Initialize the SD/SDHC card in SPI mode
//-----------------------------------------------------------------
int sd_init(void)
{
    uint32_t response;
    uint8_t sd_version = 2;
    int retries = 0;

#ifdef CONFIG_SD_CARD_SLOW
    REG_WRITE(SD_CLOCK, 1);
#else
    REG_WRITE(SD_CLOCK, 0);
#endif

    // Reset to idle state (CMD0)
    dprintf("SD: Go to IDLE state\n");
    sd_send_cmd(CMD0_GO_IDLE_STATE, 0, NULL);

    // Send CMD8 to check for SD Ver2.00 or later card
    retries = 0;
    do
    {
        // Request 3.3V (with check pattern)
        dprintf("SD: Request 3.3V\n");

        bool ok = sd_send_cmd(CMD8_SEND_IF_COND, CMD8_3V3_MODE_ARG, &response);
        if(!ok && retries++ > 4)
        {
            // No response then assume card is V1.x spec compatible
            sd_version = 1;
            break;
        }
    }
    while(response != CMD8_3V3_MODE_ARG);
    // State = IDLE

    do
    {
        // Send CMD55 (APP_CMD) to allow ACMD to be sent
        dprintf("SD: Sending CMD55\n");
        sd_send_cmd(CMD55_APP_CMD,0, &response);

       // timer_sleep(100);

        // Inform attached card that SDHC support is enabled
        dprintf("SD: Sending ACMD41\n");
        sd_send_cmd(ACMD41_SD_SEND_OP_COND, ACMD41_HOST_SUPPORTS_SDHC | (1 << 20), &response);

        bool sdhc = (response & (1 << (38-8))) != 0;
        _sdhc_card = sdhc;

        bool busy = (response & (1 << (39-8))) != 0;
        if (busy)
            break;
    }
    while (true);

    // CMD2
    uint32_t cid_resp[5];
    sd_send_cmd_r2(2, 0, cid_resp);

    // CMD3 - Get card RCA
    sd_send_cmd(3,0, &response);

    uint32_t rca = response & SDMC_R6_RCA_MASK;
    dprintf("RCA: %08x\n", rca);

    // CMD13 - Get state
    sd_send_cmd(13,rca, &response);
    dprintf("STATE: %08x\n", response);

    switch (response & SDMC_R1_CURRENT_STATE)
    {
        /* Card is in initial state the device  */
        /*   must be reopened to allow I/O  */
        case SDMC_R1_IDLE_STATE:
        case SDMC_R1_READY_STATE:
        case SDMC_R1_IDENT_STATE:
            /* TODO close and reopen the device */
            //return SYSERR;
            assert(!"Bad state");
            break;
    
        /* Standby state, issue CMD7 to select the card */
        case SMDC_R1_STBY_STATE:
            sd_send_cmd(7, rca, &response);
            break;
            
        /* Card is already in data transfer state   */
        case SDMC_R1_TRAN_STATE:
        case SDMC_R1_DATA_STATE:
        case SDMC_R1_RCV_STATE:
            break;
        
        /* Card is in some other state      */
        /*   must be reopened to allow I/O  */
        case SDMC_R1_PRG_STATE:
        case SMDC_R1_DIS_STATE:
            /* TODO close and reopen the device */
            //return SYSERR;
        assert(!"Bad state");
            break;
        
        default:
            assert(!"Bad state");
            break;
            //return SYSERR;
    }

    timer_sleep(100);

#if 1
    // Send CMD55 (APP_CMD) to allow ACMD to be sent
    dprintf("SD: Sending CMD55\n");
    sd_send_cmd(CMD55_APP_CMD, rca, &response);

    // Switch to 4-bit mode
    dprintf("SD: Sending ACMD6 (%p)\n", &response);
    sd_send_cmd(6, 2 << 0, &response);
    _wide_mode = 1;
#endif

    printf("SD: Init completed\n");
    return 1;
}
//-----------------------------------------------------------------
// sd_readsector: Read a number of blocks from SD card
//-----------------------------------------------------------------
int sd_readsector(uint32_t start_block, uint8_t *buffer, uint32_t sector_count)
{
    uint32_t response;
    uint32_t *p = (uint32_t*)buffer;
    int i;

#ifdef CONFIG_SD_MULTI_READ
    while (sector_count >= SD_BUFFER_SIZE)
    {
        sd_send_cmd_data(CMD18_READ_MULTIPLE_BLOCK, _sdhc_card ? start_block : (start_block * 512), &response, SD_BUFFER_SIZE, buffer, true);

        //for (int i=0;i<512;)
        //{
        //    printf("%d: ", i);
        //    for (int x=0;x<32;x++)
        //        printf("%02x", buffer[i++]);
        //    printf("\n");
        //}
        buffer += (SD_BUFFER_SIZE * 512);
        start_block += SD_BUFFER_SIZE;
        sector_count-= SD_BUFFER_SIZE;

        // Terminate
        sd_send_cmd(12,0, &response);
    }
#endif

    if (sector_count == 0)
        return 1;

    while (sector_count--)
    {
        sd_send_cmd_data(17, _sdhc_card ? start_block : (start_block * 512), &response, 1, buffer, false);
        buffer += 512;
        start_block++;
    }

    return 1;
}
//-----------------------------------------------------------------
// sd_writesector: Write a number of blocks to SD card
//-----------------------------------------------------------------
int sd_writesector(uint32_t start_block, uint8_t *buffer, uint32_t sector_count)
{
    uint32_t response;
    t_time tStart;
    int i;

    REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);

    uint32_t *pbuf = (uint32_t *)buffer;

    while (sector_count--)
    {
        // Fill buffer
        for (int i=0;i<512;i+=4)
            REG_WRITE(SD_TX, *pbuf++);

        // Request block write
        sd_send_cmd(CMD24_WRITE_SINGLE_BLOCK, _sdhc_card ? start_block : (start_block * 512), &response);
        start_block++;

        // Wait for data write complete
        tStart = timer_now();
        while(((REG_READ(SD_STATUS) >> SD_STATUS_DAT_IN_SHIFT) & SD_STATUS_DAT_IN_MASK) != SD_STATUS_DAT_IN_MASK)
        {
            // Timeout
            if (timer_diff(timer_now(), tStart) >= 1000)
            {
                printf("sd_writesector: Timeout waiting for data write complete (DAT=%x)\n", (REG_READ(SD_STATUS) >> SD_STATUS_DAT_IN_SHIFT) & 0xF);
                return 0;
            }
        }
    }

    REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
    return 1;
}
//-----------------------------------------------------------------
// sd_readsector_dma_start: Start async IO request
//-----------------------------------------------------------------
int sd_readsector_dma_start(uint32_t start_block, uint8_t *buffer, uint32_t sector_count)
{
    uint32_t response;
    uint32_t *p = (uint32_t*)buffer;
    int i;

    assert(sector_count <= SD_BUFFER_SIZE);
    assert((REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT)) == 0);
    assert((REG_READ(SD_STATUS) & (1 << SD_STATUS_FIFO_EMPTY_SHIFT)));

    uint32_t cmd   = CMD18_READ_MULTIPLE_BLOCK;
    uint32_t arg   = _sdhc_card ? start_block : (start_block * 512);
    uint32_t ctrl  = 0;
    uint64_t value = 0;

    assert(!(((uint32_t)buffer) & 0x1FF));
    REG_WRITE(SD_DMA, ((uint32_t)buffer));

    value |= ((uint64_t)1   << 46); // Transmission bit
    value |= ((uint64_t)cmd << 40); // Command index
    value |= ((uint64_t)arg << 8);  // Argument

    REG_WRITE(SD_CMD0, value >> 16);
    REG_WRITE(SD_CMD1, value >> 0);

    ctrl = (1 << SD_CONTROL_START_SHIFT) | (1 << SD_CONTROL_RESP48_EXP_SHIFT);
    ctrl |= (1 << SD_CONTROL_DATA_EXP_SHIFT);
    if (_wide_mode)
        ctrl |= (1 << SD_CONTROL_WIDE_MODE_SHIFT);

    ctrl |= ((sector_count-1) << SD_CONTROL_BLOCK_CNT_SHIFT);
    ctrl |= (1 << SD_CONTROL_DMA_EN_SHIFT);
    REG_WRITE(SD_CONTROL, ctrl);

    return true;
}
//-----------------------------------------------------------------
// sd_readsector_dma_end: End of async IO request
//-----------------------------------------------------------------
int sd_readsector_dma_end(void)
{
    uint32_t response;

    t_time ts = timer_now();
    while (REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT))
    {
        assert(!"ERROR: Should not be busy..");

        // Timeout
        if (timer_diff(timer_now(), ts) > 1000)
        {
            REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
            return false;
        }
    }

    // Terminate
    sd_send_cmd(12, 0, &response);

    return true;
}
//-----------------------------------------------------------------
// sd_readsector_dma_reset: Error case - reset pending request
//-----------------------------------------------------------------
void sd_readsector_dma_reset(void)
{
    REG_WRITE(SD_CONTROL, 1 << SD_CONTROL_ABORT_SHIFT);
    while (REG_READ(SD_STATUS) & (1 << SD_STATUS_BUSY_SHIFT))
        ;
}

#endif
