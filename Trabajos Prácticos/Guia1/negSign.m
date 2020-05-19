function outputArg1 = negSign(inputArg1)
%	Devuelve el signo sin ceros.
%   Si el valor original es mayor a cero, return +1
%   Si el valor original es menor a cero, return -1
%   Si el valor original es cero, return +1 o -1 con prob =0.5
    outputArg1 = sign(inputArg1);
    foundZeros = outputArg1 ==0;
    if sum(sum(foundZeros)) >0
        randomPattern = rand([size(inputArg1)]); 
        randomPattern = randomPattern <0.5; % Convierto a 1s y 0s.
        randomPattern = randomPattern*2-1;
        randomPattern = randomPattern.*foundZeros;
        outputArg1 = outputArg1+randomPattern;
    end
end

