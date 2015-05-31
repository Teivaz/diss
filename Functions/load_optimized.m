function [ output_args ] = load_optimized( name )
%LOAD_OPTIMIZED Summary of this function goes here
%   Detailed explanation goes here
output_args = 0;

    if exists_data(name)
        output_args = load(['cache/', name, '/data.mat']);
    end
end

