module Junk

export imnotdefined

function useme(args)
    @info "then you're sane"
end

macro immacro(expr)
    quote
        @warn "You shouldn't use me in most your use cases"
    end
end

module Junk2 end

end