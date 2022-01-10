function y = H(x)
    if abs(sum(x, 1:numel(size(x))) - 1) > 1e-6:
        fprintf("x is not an Entropy Vector, since sum(x) ~= 1");
        return
    y = -sum(x.*log2(x), 1:numel(size(x)));
end
