class Test
    def initialize(v1, v2)
        @v1 = v1
        @v2 = v2
    end
    
    def add()
        return @v1+@v2
    end
end

t1 = Test.new(10, 20)
p t1.add()