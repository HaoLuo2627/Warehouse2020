function [yn W err] = zx_lms(xn, dn, param)
% ����Ӧ�˲��� AF model
% xn        �����ź�
% dn       �������
% param    Structure for using LMS, must include at least
%          .w        - ��ʼ��Ȩֵ
%          .u        - ѧϰ��
%          .N        - �˲�������
%          .max_iter - ����������
%          .min_err  - ������С���
%
% y        �����˲����������ź�
% error    ������

W = param.w;  % ��ʼȨֵ
M = param.N;  % �˲�������

if length(W) ~= M
    error('param.w�ĳ��ȱ������˲���������ͬ.\n');
end
% if param.max_iter > length(xn) || param.max_iter < M
%     error('��������̫���̫С��M<=max_iter<=length(xn)\n');    
% end

iter  = 0;
for k = M:param.max_iter
    x    = xn(k:-1:k-M+1);   % �˲���M����ͷ������
    y    = W.*x;
    err  = dn(k) - y;
    
    % �����˲���Ȩֵϵ��
    W = W + 2*param.u*x;
    
    iter = iter + 1;    
    if (abs(err) < param.min_err)
        break; 
    end
end

% ������ʱ�˲������������
yn = inf * ones(size(xn));
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
    yn(k) = W(:,end).' * x;
end

end