function  out = CRC_testing(robot_obj)
str=fscanf(robot_obj);
if length(str)  < 1
    out =str;
else
    
    dec_crc=fread(robot_obj,7);
    int_crc=uint8(dec_crc);
    high_byte=bitshift(int_crc(2),4)+int_crc(3);
    low_byte=bitshift(int_crc(4),4)+int_crc(5);
    crc_str = [ str dec_crc(1) char(high_byte) char(low_byte)];
    my_val= CRC16(crc_str);
    comp_arr=[char(0) char(0)];
    if(strcmp(my_val,comp_arr))
        out=str;
    else
        out='';
    end
end
end