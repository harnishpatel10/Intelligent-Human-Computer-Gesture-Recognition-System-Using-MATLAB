function feat = jfemg(type,X,opts)
switch type
  case 'rms'    ; fun = @jRootMeanSquare; 
  case 'mav'    ; fun = @jMeanAbsoluteValue;
  case 'zc'     ; fun = @jZeroCrossing; 
  case 'wl'     ; fun = @jWaveformLength;
end
if nargin < 3
  opts = [];  
end
feat = fun(X,opts);
end

