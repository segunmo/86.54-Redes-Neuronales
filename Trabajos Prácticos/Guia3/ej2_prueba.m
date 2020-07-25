clear all
N=40;
patrones = zeros([2 N]);

for i=1:N
    patrones(:,i) = rand([2 1]);
end

T = 1.5*N;
matriz = rand([2 T]);
matriz = matriz/5+[0.4;0.4];

iteracion = 0;

figure(1)

sigma = 10;
eta = 0.1;

for epoch=1:20
    orden = randperm(length(patrones));
    for k = 1:length(patrones)
        mascara = zeros([2 T]);
        %elijo un vector
        elegido = patrones(:,orden(k));
        %busco al mayor de las neuronas y obtengo la posición en espacio neurona
        matriz_elegido = ones([2 T]).*elegido;
        diferencia = matriz_elegido-matriz;
        norma = (diferencia(1,:).^2+diferencia(2,:).^2).^(1/2);
        [valor,posicion] = min(norma(:));
        %creo la matriz de pesos de update
        for l = 0:T/2
            if (l+posicion<=T)
                mascara(:,posicion+l) = exp(-((l)^2)/(2*sigma^2));
            else
                mascara(:,posicion+l-T) = exp(-((l)^2)/(2*sigma^2));
            end
        end
        for l = 0:-1:-T/2
            if (l+posicion>0)
                mascara(:,posicion+l) = exp(-((l)^2)/(2*sigma^2));
            else
                mascara(:,T+posicion+l) = exp(-((l)^2)/(2*sigma^2));
            end
        end
        delta = eta*(diferencia).*mascara;
        matriz = matriz+ delta;

    end

    sigma = 2-epoch/250;
    
    clf
    hold on
    scatter(matriz(1,:), matriz(2,:),'blue')
    plot(matriz(1,:), matriz(2,:),'blue')
    scatter(patrones(1,:), patrones(2,:), 'red')
    grid on
    axis([0 1 0 1])
    annotation('textbox', [0.9 0.9 0.1 0.1,], 'String',num2str(iteracion) )
    drawnow
    iteracion = iteracion+1;
end


sigma =3;% T/20;
eta = 0.05;

for epoch=1:500
    orden = randperm(length(patrones));
    for k = 1:length(patrones)
        mascara = zeros([2 T]);
        %elijo un vector
        elegido = patrones(:,orden(k));
        %busco al mayor de las neuronas y obtengo la posición en espacio neurona
        matriz_elegido = ones([2 T]).*elegido;
        diferencia = matriz_elegido-matriz;
        norma = (diferencia(1,:).^2+diferencia(2,:).^2).^(1/2);
        [valor,posicion] = min(norma(:));
        %creo la matriz de pesos de update
        for l = 0:T/2
            if (l+posicion<=T)
                mascara(:,posicion+l) = exp(-((l)^2)/(2*sigma^2));
            else
                mascara(:,posicion+l-T) = exp(-((l)^2)/(2*sigma^2));
            end
        end
        for l = 0:-1:-T/2
            if (l+posicion>0)
                mascara(:,posicion+l) = exp(-((l)^2)/(2*sigma^2));
            else
                mascara(:,T+posicion+l) = exp(-((l)^2)/(2*sigma^2));
            end
        end
        delta = eta*(diferencia).*mascara;
        matriz = matriz+ delta;

    end
    if sigma>0.1
        sigma = sigma*0.995;
    end
    
    pos_rand = randi(T,1);
    matriz(:,pos_rand) = matriz(:,pos_rand)+rand([2,1])*0.01;
    
    clf
    hold on
    scatter(matriz(1,:), matriz(2,:),'blue')
    plot(matriz(1,:), matriz(2,:),'blue')
    plot([matriz(1,end) matriz(1,1)],[matriz(2,end) matriz(2,1)],'blue')
    scatter(patrones(1,:), patrones(2,:), 'red')
    grid on
    axis([0 1 0 1])
    annotation('textbox', [0.9 0.9 0.1 0.1,], 'String',num2str(iteracion) )
    drawnow
    iteracion = iteracion+1;
end