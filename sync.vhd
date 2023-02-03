library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync is
    generic(
        BAUDRATE: positive :=9600;
        N       : positive :=4
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        pulse   : out std_logic
    );
end sync;

architecture rtl of sync is
    constant CLK_Hz: integer :=50000000;
    constant CUENTA: integer :=CLK_Hz/(BAUDRATE*N);
    signal counter : integer range 0 to CUENTA;
    
begin

    Counting_PROC : process(clk,rst)
    begin
        if(rst='1')then
            counter <= 0;
            pulse <= '0';
        elsif(rising_edge(clk))then
            
            if(counter>=CUENTA-1)then
                pulse <= '1';
                counter <= 0;
            else
                pulse <= '1';
                counter <= counter +1;
            end if;
        end if;
    end process;

end architecture;