module Computer
  def self.run(mem, inp: STDIN, outp: STDOUT)
    mem = Mem.new(mem) # wrap to give zeros on out-of-bounds reads
    pc = 0
    relbase = 0

    loop do
      opcode = mem[pc].to_s
      opcode = "0" * (5 - opcode.length) + opcode
      cmd = opcode[-2,2].to_i
      cmdlen, args = case cmd
      when 99; [1, []]
      when 1, 2, 7, 8; [4, mem[pc+1, 3]]
      when 5, 6; [3, mem[pc+1, 2]]
      when 3, 4, 9; [2, mem[pc+1, 1]]
      else raise("Invalid cmd #{cmd} at #{pc}")
      end
      args.length.times do |i|
        mode = opcode[-(3+i)].to_i
        args[i] = case mode
        when 0; MemCell.new(mem, args[i])
        when 1; ImmCell.new(args[i])
        when 2; MemCell.new(mem, args[i] + relbase)
        end
      end
      newpc = pc + cmdlen

      case cmd
      when 99
        break
      when 1, 2, 7, 8
        alg = {
          1 => ->(a,b) { a+b },
          2 => ->(a,b) { a*b },
          7 => ->(a,b) { a<b ? 1 : 0 },
          8 => ->(a,b) { a==b ? 1 : 0 },
        }
        a1, a2, dst = args
        dst.write(alg[cmd].(a1.read, a2.read))
      when 3
        print("> ") if inp.tty?
        v = Integer(inp.gets)
        args[0].write(v)
      when 4
        outp.puts(args[0].read)
      when 5, 6
        tst = args[0].read != 0
        tst = !tst if cmd == 6
        newpc = args[1].read if tst
      when 9
        relbase += args[0].read
      end
      pc = newpc
    end
    mem.mem
  rescue
    STDERR.print mem
    STDERR.puts
    raise
  end

  class Mem < Struct.new(:mem)
    def [](*a)
      raise("invalid index #{a}") if a[0] < 0
      mem[*a] || 0
    end

    def []=(idx, val)
      raise("invalid index #{idx}") if idx < 0
      mem[idx] = val
    end
  end

  class MemCell < Struct.new(:mem, :pos)
    def read
      mem[pos]
    end

    def write(val)
      mem[pos] = val
    end
  end

  class ImmCell < Struct.new(:read)
  end
end