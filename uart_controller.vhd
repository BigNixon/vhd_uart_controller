library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- use work.myPackage.all;

entity uart_controller is
    generic(
        BITS: positive := 8;
        BAUD_RATE: positive := 9600
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        rx  : in std_logic;
        caracter: out std_logic_vector(BITS-1 downto 0)
    );
end uart_controller;

architecture rtl of uart_controller is

    type state_type is (IDDLE_S, START_S, RECEIVING_S, STOP_S);
    signal state : state_type;
     signal leds : std_logic_vector(2 downto 0);
    signal pulse : std_logic;
    signal registro_rx : std_logic_vector(BITS-1 downto 0 );
    signal buffer_rx : std_logic_vector(BITS-1 downto 0);
    signal cont_bits: unsigned(4 downto 0);
    signal cont_pulses: unsigned(5 downto 0);

    constant N                 : integer := 8;
    constant CANTIDAD_PULSOS   : integer := N - 1;

begin

    SYNC_INST: entity work.sync generic map(
        BAUDRATE => BAUD_RATE,
        N => N
    )
    port map(
        clk => clk,
        rst => rst,
        pulse => pulse
    );

    RX_PROC : process(pulse, rst)
    begin
        if(rst='1')then
            registro_rx <= (others=>'0');
            buffer_rx <= (others => '0');
            state <= IDDLE_S;
            leds <= "000";
        elsif(rising_edge(pulse))then
            case state is
                when IDDLE_S =>
                    cont_pulses<=(others=>'0');
                    cont_bits<=(others=>'0');
                    registro_rx <= (others=>'0');
                     leds <= "000";
                    if(rx='0')then
                        state <= START_S;
                    end if;
                when START_S =>
                 leds <= "001";
                    if (cont_pulses<CANTIDAD_PULSOS/2) then
                        cont_pulses <= cont_pulses +1;
                    else
                        cont_pulses<=(others=>'0');
                        if(rx='0')then
                            state <= RECEIVING_S;
                        else
                            state <= IDDLE_S;
                        end if;
                    end if;
                when RECEIVING_S =>
                 leds <= "010";
                    if (cont_pulses < CANTIDAD_PULSOS) then
                        cont_pulses <= cont_pulses + 1;
                    else
                        cont_pulses<=(others=>'0');
                        if(cont_bits<BITS)then
                            registro_rx <= rx & registro_rx(BITS-1 downto 1);
                            cont_bits <= cont_bits +1;
                        else
                            state <= STOP_S;
                            cont_bits <= (others=>'0');
                        end if;
                    end if;
                when STOP_S =>
                 leds <= "011";
                    if (cont_pulses < CANTIDAD_PULSOS) then
                        cont_pulses <= cont_pulses + 1;
                    else
                        cont_pulses<=(others=>'0');
                        state <= IDDLE_S;
                        buffer_rx <= registro_rx;
                    end if;


            end case;
        end if;
    end process;

    caracter<=buffer_rx;


    
end architecture;