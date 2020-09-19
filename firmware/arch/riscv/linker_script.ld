GROUP("libgcc.a")

MEMORY
{
  sram (rwx) : ORIGIN = BASE_ADDRESS, LENGTH = MEM_SIZE
}

SECTIONS
{	
	/* first section is .text which is used for code */
	.text :
	{
    *(.boot)
    KEEP(*(.boot))

		*(.text .text.*)           /* remaining code */
		*(.rodata)                 /* read-only data (constants) */
		*(.rodata*)
		*(.rdata*)
		. = ALIGN(4);
	} > sram

	/* .data section which is used for initialized data */
	.data : 
	{
    *(.got.plt) *(.got)
    *(.shdata)
    *(.data .data.* .gnu.linkonce.d.*)
    . = ALIGN(16);
    *(.lit8)
    *(.lit4)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    . = ALIGN (8);
    *(.ram)
    . = ALIGN (8);
    _edata = .;
	} > sram	
     
  .bss : 
  {
	. = ALIGN(4);
    _bss_start = . ;
    
    *(.bss*)
    *(.sbss*)
    *(COMMON)
    /* Allocate room for stack */
    .   =  ALIGN(8) ;
    .   += 4096 ;
    _sp =  . - 16;
  } > sram

  . = ALIGN(4);
  _end = . ;

  .payload :
  {
    *(.payload)
  }
}
