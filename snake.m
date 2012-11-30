function out = snake(row,n)
out = [row(end-n+1:end) row(1:end - n)];
end