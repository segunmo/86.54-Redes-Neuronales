function salida = actualizacionAsincronica(MatrizPesos,Patron, terminacion, cantIter)
%La función realiza la actualización asincrónica de la red
%   Recibe dos argumentos obligatorios y dos opcionales.
%   Con el argumento terminacion decido como voy a parar, si hasta
%   encontrar un punto estable, o por cantidad de iteraciones a la matriz.
%   Por defecto la función actualiza una sola vez a la red.
%   Los posibles valores de terminacion son 'porCant' y 'ptoEstable'
if nargin <3
    terminacion = 'porCant';
    cantIter = 1;
elseif nargin < 4
    cantIter = 1;
end

salidaPreliminar = Patron;
salida = Patron*0;
aux = salida;
if terminacion == 'porCant'
    for i=1:cantIter;
        orden = randperm(length(Patron));
        for j=1:length(orden)
            aux = negSign(MatrizPesos(orden(j),:)*salidaPreliminar);
            salida(orden(j))=aux;
        end
        if isequal(salida,salidaPreliminar);
            break
        end
        salidaPreliminar=salida;
    end
elseif terminacion =='ptoEstable'
    while(true);
        orden = randperm(length(Patron));
        for j=1:length(orden)
            aux = negSign(MatrizPesos(orden(j),:)*salidaPreliminar);
            salida(orden(j))=aux;
        end
        if isequal(salida,salidaPreliminar);
            break
        end
        salidaPreliminar=salida;
    end
end
end

