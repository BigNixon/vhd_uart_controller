library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use std.textio.all;
use std.env.finish;

entity uart_controller_tb is
end uart_controller_tb;

architecture sim of uart_controller_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    signal rx_in  : std_logic := '1';
    signal ch_out : std_logic_vector(7 downto 0);
    constant CUENTA: integer :=10;

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.uart_controller(rtl)
    generic map(
        BAUD_RATE => 9600,
        BITS => 8
    )
    port map (
        clk => clk,
        rst => rst,
        rx  => rx_in,
        caracter => ch_out
    );

    SEQUENCER_PROC : process
    begin
        wait for clk_period * 2;

        rst <= '0';
        wait for clk_period * 10;
        
        rx_in <= '0';--start bit
        wait for clk_period * CUENTA*10;
        rx_in <= '1';--1 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '0';--2 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '1';--3 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '0';--4 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '1';--5 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '0';--6 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '1';--7 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '0';--8 bit
        wait for clk_period * CUENTA*10;
        rx_in <= '1';--stop bit
        wait for clk_period * CUENTA*10;
        
        
        assert false
        	report "FINISH TESTBENCH" severity failure;
        finish;
    end process;

end architecture;