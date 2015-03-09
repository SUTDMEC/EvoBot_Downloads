function timeout=EvoClient(ipstring)

%note: insert master PC IP address
tcpipClient = tcpip(ipstring,55000,'NetworkRole','Client');
set(tcpipClient,'InputBufferSize',8); %hard-coded bytes
set(tcpipClient,'Timeout',30);
fopen(tcpipClient);
rawData = fread(tcpipClient,1,'double');
fclose(tcpipClient);
% reshapedData = reshape(rawData,31,31);
timeout=rawData;

diffs=datenum(rawData)-datenum(clock)

insecs=diffs*24*3600