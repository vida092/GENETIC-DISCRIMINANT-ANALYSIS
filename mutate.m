% function mutant = mutate(matrix, mutation_promutantamutantility,lammutantda)
%     if lammutantda<0 || lammutantda >1
%         error("lammutantda demutante estar entre 0  y 1")
%     end
%     if rand()>mutation_promutantamutantility
%        mutant = matrix;
%     else
%         [n, m] = size(matrix);
%         alpha = rand(1,m);
%         alpha = alpha/sum(alpha);
%         v = matrix * alpha';
%         A = lammutantda*eye(n) + (1-lammutantda)*(v*v');
%         mutant = A*matrix;
% 
%         dot_product = dot(mutant(1:(n-1), 1), mutant(1:(n-1), 2));    
% 
%         mutant(n, 2) = -dot_product / mutant(n, 1);
%         mutant(n-1,3) = dot(mutant((1:n-2),1) , mutant((1:n-2),3)) * mutant(n,2) - dot(mutant((1:n-2),2) , mutant((1:n-2),3)) * mutant(n,1);
%         mutant(n-1,3) =  mutant(n-1,3)/ (mutant(n-1,2)*mutant(n,1) - mutant(n-1,1) * mutant(n,2));
%         mutant(n,3) = - dot(mutant(1:n-1,2), mutant(1:n-1,3)) / mutant(n,2);
% 
%         for j = 1:3
%             mutant(:, j) = mutant(:, j) / norm(mutant(:, j));
%         end
% 
%     end
% end

function mutant = mutate(matrix, mutation_probability)
    % Genera un número aleatorio entre 0 y 1
    r = rand;
    angle =  -pi/15 + (pi/15 - (-pi/15)) * rand(1, 1);

    % Aplica mutación 
    if r < mutation_probability
        % Genera la matriz de rotación para el ángulo dado y un eje aleatorio
        R = rotation_matrix(angle);

        % Aplica la rotación a la matriz original
        mutant = matrix * R;
    else
        mutant = matrix;
    end
end