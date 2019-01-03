function ucb(;n_ij, n_i, q)
    return (q / n_ij) + sqrt((2. * log(n_i))/n_ij)
end

function rs(;n_ij, q, r)
    return n_ij * ((q/n_ij) - r)
end
