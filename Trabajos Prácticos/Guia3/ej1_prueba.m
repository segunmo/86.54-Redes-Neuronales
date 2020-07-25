clear all
N=1000;%numero de patrones
T = 30; %Red neuronal de TxT
patrones = zeros([2 N]);
iteracion = 0;
%creo los patrones

%Patron circular con perimetro
% for i=1:N
%     aceptado = false;
%     while ~aceptado
%         aux = rand([2 1]);
%         if ((aux(1)-0.5)^2 + (aux(2)-0.5)^2 < 0.5^2)
%             patrones(:,i) = (aux-0.5)*2;
%             aceptado = true;
%         else
%             aceptado = false;
%         end
%     end
% end
% patrones = [patrones zeros([2 N/4])];
% for i=1:N/4
%     aux = rand([1])*2*pi;
%     patrones(:,N+i) = [cos(aux) sin(aux)];
% end

%Patron cuadrado
% for i=1:N
%     patrones(:,i) = rand([2 1])*2-1;
% end

%Patron anillo
% for i=1:N
%     aceptado = false;
%     while ~aceptado
%         aux = rand([2 1])*2-1;
%         if norm(aux) < 1 && norm(aux) >0.5
%             patrones(:,i) = aux;
%             aceptado = true;
%         else
%             aceptado = false;
%         end
%     end
% end

%Patron sonrisa, funciona mejor con T>20 neuronas
for i=1:N
    aceptado = false;
    while ~aceptado
        aux = rand([2 1]);
        if ((aux(1)-0.5)^2 + (aux(2)-0.5)^2 < 0.5^2)
            patrones(:,i) = (aux-0.5)*2;
            aceptado = true;
        else
            aceptado = false;
        end
    end
end

patrones = [patrones zeros([2 N/5])];

for i=1:N/5
    aceptado = false;
    while ~aceptado
        aux = rand([2 1]);
        if ((aux(1)-0.5)^2 + (aux(2)-0.5)^2 < 0.5^2)
            patrones(:,N+i) = (aux-0.5)*0.2+[0.3;0.4];
            aceptado = true;
        else
            aceptado = false;
        end
    end
end
patrones = [patrones zeros([2 N/5])];
for i=1:N/5
    aceptado = false;
    while ~aceptado
        aux = rand([2 1]);
        if ((aux(1)-0.5)^2 + (aux(2)-0.5)^2 < 0.5^2)
            patrones(:,N+N/5+i) = (aux-0.5)*0.2+[-0.3;0.4];
            aceptado = true;
        else
            aceptado = false;
        end
    end
end

patrones = [patrones zeros([2 3*N/5])];
angulo_menor=-1*pi+0.5;
angulo_mayor = -0.5;
for i=1:3*N/5
    aceptado = false;
    while ~aceptado
        aux = rand([2 1])*2-1;
        if norm(aux)< 0.55 && norm(aux)>0.35 && atan2(aux(2),aux(1))<angulo_mayor && atan2(aux(2),aux(1))>angulo_menor
            patrones(:,N+2*N/5+i) = aux;
            aceptado=true;
        else
            aceptado = false;
        end
    end
end


patrones = [patrones zeros([2 N])];
for i=1:N
    aux = rand([1])*2*pi;
    patrones(:,2*N+i) = [cos(aux) sin(aux)];
end

%Creo la matriz de pesos 
matriz = rand([T T 2]);
matriz = matriz/5-0.1;

figure(1)
x = -1:0.01:1;
sigma = 6;
eta = 0.02;
for epoch=1:10
    orden = randperm(length(patrones));
    for k = 1:length(patrones)
        mascara = zeros([T T]);
        %elijo un vector
        elegido = patrones(:,orden(k));
        %busco al mayor de las neuronas y obtengo la posición en espacio neurona
        matriz_elegido = ones([T T 2]);
        matriz_elegido(:,:,1) = matriz_elegido(:,:,1)*elegido(1);
        matriz_elegido(:,:,2) = matriz_elegido(:,:,2)*elegido(2);
        diferencia = matriz_elegido-matriz;
        norma = (diferencia(:,:,1).^2+diferencia(:,:,2).^2).^(1/2);
        [valor,posicion] = min(norma(:));
        pos_y = mod(posicion,T);
        if pos_y==0
            pos_y=T;
        end
        pos_x = (posicion-pos_y)/T+1;
        %creo la matriz de pesos de update
        for l = 1:T
            for m = 1:T
                %mascara(l,m) = (1-((l-pos_x)/(sigma*1.5))^2*((m-pos_y)/(sigma*1.5))^2)*exp(-((l-pos_x)^2+(m-pos_y)^2)/(2*sigma^2));
                mascara(m,l) = exp(-((l-pos_x)^2+(m-pos_y)^2)/(2*sigma^2));
            end
        end
        delta = eta*(diferencia).*mascara;
        matriz(:,:,1) = matriz(:,:,1)+ delta(:,:,1);
        matriz(:,:,2) = matriz(:,:,2)+ delta(:,:,2);

    end
    sigma = sigma*0.9;
    
    clf
    hold on
    for j=1:T
        scatter(matriz(:,j,1), matriz(:,j,2),'blue')
        if j==1 || j==T
            plot(matriz(:,j,1), matriz(:,j,2),'green')
            plot(matriz(j,:,1), matriz(j,:,2),'red')
        else
            plot(matriz(:,j,1), matriz(:,j,2),'blue')
            plot(matriz(j,:,1), matriz(j,:,2),'blue')
        end
        plot(x,sqrt(1-x.^2),'k')
        plot(x,-1*sqrt(1-x.^2),'k')
    end
    axis([-1.1 1.1 -1.1 1.1])  
    annotation('textbox', [0.9 0.9 0.1 0.1,], 'String',num2str(iteracion) )
    drawnow
    iteracion = iteracion+1;
end


sigma = 1.5;
eta = 0.05;

for epoch=1:50
    orden = randperm(length(patrones));
    for k = 1:length(patrones)
        mascara = zeros([T T]);
        %elijo un vector
        elegido = patrones(:,orden(k));
        %busco al mayor de las neuronas y obtengo la posición en espacio neurona
        matriz_elegido = ones([T T 2]);
        matriz_elegido(:,:,1) = matriz_elegido(:,:,1)*elegido(1);
        matriz_elegido(:,:,2) = matriz_elegido(:,:,2)*elegido(2);
        diferencia = matriz_elegido-matriz;
        norma = (diferencia(:,:,1).^2+diferencia(:,:,2).^2).^(1/2);
        [valor,posicion] = min(norma(:));
        pos_y = mod(posicion,T);
        if pos_y==0
            pos_y=T;
        end
        pos_x = (posicion-pos_y)/T+1;
        %creo la matriz de pesos de update
        for l = 1:T
            for m = 1:T
                %mascara(m,l) = (1-((l-pos_x)/(sigma*1.3))^2*((m-pos_y)/(sigma*1.3))^2)*exp(-((l-pos_x)^2+(m-pos_y)^2)/(2*sigma^2));
                mascara(m,l) = exp(-((l-pos_x)^2+(m-pos_y)^2)/(2*sigma^2));

            end
        end
        delta = eta*(diferencia).*mascara;
        matriz(:,:,1) = matriz(:,:,1)+ delta(:,:,1);
        matriz(:,:,2) = matriz(:,:,2)+ delta(:,:,2);

    end
    if sigma>0.1
        sigma = sigma-0.01;
    end
    eta = eta*0.999;
    
    clf
    hold on
    for j=1:T
        scatter(matriz(:,j,1), matriz(:,j,2),'blue')
        if j==1 || j==T
            plot(matriz(:,j,1), matriz(:,j,2),'green')
            plot(matriz(j,:,1), matriz(j,:,2),'red')
        else
            plot(matriz(:,j,1), matriz(:,j,2),'blue')
            plot(matriz(j,:,1), matriz(j,:,2),'blue')
        end
        plot(x,sqrt(1-x.^2),'k')
        plot(x,-1*sqrt(1-x.^2),'k')
    end
    axis([-1.1 1.1 -1.1 1.1])  
    annotation('textbox', [0.9 0.9 0.1 0.1,], 'String',num2str(iteracion) )
    drawnow
    iteracion=iteracion+1;
end