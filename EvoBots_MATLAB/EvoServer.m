function EvoServer()
%sends time to remote

data = datenum(clock);
datestr(data,'HH:MM:SS:FFF')
s = whos('data');
tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');
 set(tcpipServer,'OutputBufferSize',s.bytes);
  fopen(tcpipServer);
  
  fwrite(tcpipServer,data(:),'double');
  %keyboard
 fclose(tcpipServer);