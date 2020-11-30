# ASK2CB (and ASK2CA) FPGA dev board resources

![ASK2CB](https://pomf.soupwhale.com/cjtxuy.jpg)

Example code and documentation for the DIGIASIC/BAIXUN ASK2CB Cyclone II
FPGA development board (and the similar ASK2CA).

If you want a cheap Chinese FPGA dev board, this might have been a good
choice in 2011. There are probably better options out there now, but if
you're stuck with this one it can be hard to find good documentation for
it.

This repo contains everything I've found on this board through
Google/Baidu, board markings, and [a nice
person](https://hackaday.io/UncleYong) on Hackaday.io.

Pull requests with additional information very welcome. In particular
I'm still looking for the sources for the design stored on the EPCS4
when I got the board.

## Board specs (rev V1.0)

*These specs may differ slightly from revision to revision.*

**Note: Many pins are shared between peripherals, consult the documentation.**

- Altera® Cyclone II EP2C8Q208C8N
- 50MHz crystal
- EPCS4 serial configuration device
- JTAG port (USB Blaster-compatible)
- AS port (USB Blaster-compatible)
- 64Mb flash (S29GL064N, [datasheet](https://www.cypress.com/file/202426/download), **wrong in schematic**)
- 256Mb SDRAM (H57V2562GTR, [datasheet](http://www.farnell.com/datasheets/1382720.pdf))
- 4Mb SRAM (IS61LV25616AL, [datasheet](http://www.issi.com/WW/pdf/61LV25616AL.pdf))
- 2Kb I2C EEPROM? (U8: 24LC02 on schematic, ATMLH112 chip marking, clone?)
- 16x2 character display (YJD1602A-1)
- Terasic DE0/DE2-compatible 40-pin expansion header (located under character display)
- 50-pin FPC connector (for external LCD, on bottom of board)
- VGA port with R3G3B2 resistor ladder
- RS232 with UART driver (+ activity LEDs)
- 6 push buttons:
  - 1 red (S1) programs from EPCS4
  - 1 blue (S2): user programmable
  - 4 white (S3-S6): user programmable
- 8 slide switches
- 8 7-segment (+ DP) displays (can be disabled with jumper (CON11)?)
- Piezo buzzer
- SD card slot
- IR receiver
- 1 PS/2 port (mouse/keyboard)
- 5V/2A barrel input power (+ power switch and LED)

## Files

- `docs/`
  - [`schematic.pdf`](/docs/schematic.pdf): ASK2CB board schematic (with pin numbers)
  - [`hardware_list.pdf`](/docs/hardware_list.pdf): additional info for major board parts
  - [`YJD1602A-1.pdf`](/docs/YJD1602A-1.pdf): character display datasheet

- `examples/` (converted to UTF-8)
  - [`ep2c5q208/`](/examples/ep2c5q208): vendor examples for the EP2C5 model (ASK2CA?)
  - [`ep2c8q208/`](/examples/ep2c8q208): vendor examples for the EP2C8 model (ASK2CB?)

- `dumps/`
  - [`epcs4.pof`](/dumps/epcs4.pof): dump of my board's EPCS4 config device

## Additional resources

* [Pin template file](http://www.amos.eguru-il.com/FILES/ASK2CB_PINS.tcl)
* [Pin table (Baidu docs link)](https://wenku.baidu.com/view/ef70ab4ee45c3b3567ec8b26.html)
* [Quartus II 13.0sp1 Web Edition](https://fpgasoftware.intel.com/13.0sp1/) (last version to support Cyclone II)
