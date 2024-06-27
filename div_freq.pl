#!/usr/bin/perl -w

#$clk = 50_000_000;
$clk = 1_000_000;
$counter_bits = 16;
for ($i = (2**$counter_bits)-1; $i>=0; $i--){
    $f = $i ? ($clk / $i) * 0.5 : $clk;  
    printf "%05d, %.2f, %04x\n",$i,$f,$i;
}
