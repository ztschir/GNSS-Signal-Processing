function [yhist, count] = binloadSamples(fid,N,DATATYPE)
% [yhist, count] = binloadSamples(fid,N,DATATYPE)
%
% Reads N front-end samples from the binary file pointed to by fid.  The file
% pointer is updated so that repeated calls to this function return
% consecutive batches of front-end samples. DATATYPE is either 'single' for
% single-frequency data or 'dual' for dual-frequency data.
%
% Input data format:
%
% single:  [m0 m1 ... m15| s0 s1 ... s15] 
%
%   dual:  [m0 m1 ... m8 | m0 m1 ... m8 | s0 s1 ... s8 | s0 s1 ... s8] 
%          where in the dual-frequency format the magnitude and sign data
%          are organized in bytes as [L1 mag | L2 mag | L1 sign | L2 sign] 
%
% INPUTS:
%
% fid ------- The identifier for the file containing the 2-bit binary
%             bit-packed data.  fid is returned by the fopen() function as in
%             fid = fopen(filename,'r','l') where 'r' denotes read and 'l'
%             denotes little-endian storage.
%
%
% N --------- The number of front-end samples in yhist.  Each sample
%             corresponds to two bits of data in the file identified by fid.
%             In order for data samples to line up with 32-bit boundaries, N
%             must be divisible by 16.
%
% DATATYPE -- 'single' ---- single-frequency data
%             'dual' ------ dual-frequency data
%
% OUTPUTS:
%
% yhist ----- count-by-nSignals vector of front-end samples, where nSignals =
%             1 for single frequency data and 2 for dual-frequency data.
%             Samples are expressed as +-1 ant +-3 values.
%
% count ----- A scalar value equal to the length of yhist.  If count is not
%             equal to N, then there were fewer than N remaining samples in
%             the file pointed to by fid.
%
% Todd Humphreys

  fitSize = 0;
  if(strcmp(DATATYPE,'single'))
    fitSize = 16;
    if (mod(N,fitSize)~=0)
      error(['Requested chunksize should be divisible', ...
             'by 16 in order to read the 2-bit encoded data',...
             'on 32-bit boundaries.']);
    end
  elseif(strcmp(DATATYPE,'dual'))
    fitSize = 8;
    if (mod(N,fitSize)~=0)
      error(['Requested chunksize should be divisible', ...
             'by 8 in order to read the 2-bit encoded data',...
             'on 32-bit boundaries.']);
    end
  else
    error('Unrecognized DATATYPE');
  end
  
  % The asterisk in the line below ensures that the input data is not only read
  % as uint32 but is also stored as uint32.
  [rawData,loadCount] = fread(fid,N/fitSize,'*uint32');
  if(strcmp(DATATYPE,'single'))
    y1 = convertBitPackedData(rawData);
    yhist = y1;
    count = length(y1);
  elseif(strcmp(DATATYPE,'dual'))
    [y1,y2] = convertBitPackedData(rawData);
    yhist = [y1,y2];
    count = length(y1);
  else
    error('Unrecognized DATATYPE');
  end
  
   
   