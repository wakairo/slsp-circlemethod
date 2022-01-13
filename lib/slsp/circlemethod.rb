require_relative "circlemethod/version"

# The SLSP module defines methods for Sports League Scheduling Problems
module SLSP
  # The Circlemethod module defines methods using the circle method for Sports League Scheduling Problems
  module CircleMethod

    module InternalUseOnly # :nodoc: all
      def self.convert_to_non_negative_int n
        unless n.respond_to?(:to_int)
          raise TypeError.new("no implicit conversion of #{n.class} into Integer")
        end
        i = n.to_int
        if i < 0
          raise RangeError.new("#{n} must be a non-negative value")
        end
        i
      end

      def self.each_of_even(n)
        n_1 = n-1
        n_1.times do |i|
          q = i + 1
          r = q + n - 3
          yield [i, n_1]
          (n/2-1).times do |j|
            yield [q%n_1, r%n_1]
            q+=1
            r-=1
          end
        end
      end
      def self.each_of_odd(n)
        n.times do |i|
          q = i + 1
          r = q + n - 2
          ((n+1)/2-1).times do |j|
            yield [q%n, r%n]
            q+=1
            r-=1
          end
        end
      end
      
      def self.each_with_fair_break_of_even(n)
        n_1 = n-1
        n_1.times do |i|
          q = i + 1
          r = q + n - 3
          yield(
            if 0==i or i.odd?
              [i, n_1]
            else
              [n_1, i]
            end
          )
          (n/2-1).times do |j|
            yield(
              if j.even?
                [r%n_1, q%n_1]
              else
                [q%n_1, r%n_1]
              end
            )
            q+=1
            r-=1
          end
        end
      end
      def self.each_with_fair_break_of_odd(n)
        n.times do |i|
          q = i + 1
          r = q + n - 2
          ((n+1)/2-1).times do |j|
            yield(
              if j.even?
                [r%n, q%n]
              else
                [q%n, r%n]
              end
            )
            q+=1
            r-=1
          end
        end
      end
    end

    # call-seq:
    #    CircleMethod.each(n){|pair| ... }  -> nil
    #    CircleMethod.each(n) -> new_enumerator
    #
    # Calls the block with pairs of two different integers,
    # whose correspond to +n+ teams, and
    # returns +nil+.
    #
    # +n+ must be a non-negative integer.
    #
    # Example 1:
    #    SLSP::CircleMethod.each(4){|match| p match }
    # Output:
    #    [0, 3]
    #    [1, 2]
    #    [1, 3]
    #    [2, 0]
    #    [2, 3]
    #    [0, 1]
    #
    # Example 2:
    #    teams = %w(A B C D)
    #    SLSP::CircleMethod.each(teams.size){|p,q| puts "#{teams[p]} vs #{teams[q]}" }
    # Output:
    #    A vs D
    #    B vs C
    #    B vs D
    #    C vs A
    #    C vs D
    #    A vs B
    #
    # If no block is given, returns a new Enumerator that will enumerate with the pairs.
    # Example 3:
    #    teams = %w(A B C D)
    #    enum = SLSP::CircleMethod.each(teams.size) #=> #<Enumerator: SLSP::CircleMethod:each(4)>
    #    enum.each_slice(teams.size/2).each_with_index do |x, i|
    #        puts "Round #{i}: " + x.map{|p,q| "#{teams[p]} vs #{teams[q]}"}.join(", ")
    #    end
    # Output:
    #    Round 0: A vs D, B vs C
    #    Round 1: B vs D, C vs A
    #    Round 2: C vs D, A vs B
    #
    def self.each(n, &block)
      i = InternalUseOnly.convert_to_non_negative_int(n)
      unless block_given?
        return enum_for(__method__, i){ i*(i-1)/2 }
      end
      if i.even?
        InternalUseOnly.each_of_even(i, &block)
      else
        InternalUseOnly.each_of_odd(i, &block)
      end
      nil
    end
    
    # call-seq:
    #    CircleMethod.each_with_fair_break(n){|pair| ... }  -> nil
    #    CircleMethod.each_with_fair_break(n) -> new_enumerator
    #
    # Calls the block with pairs of two different integers,
    # whose correspond to +n+ teams,
    # where all teams have the same number of breaks, and
    # returns +nil+.
    #
    # +n+ must be a non-negative integer.
    #
    # About breaks, see the following paragraph.
    #
    # Example 1:
    #    SLSP::CircleMethod.each_with_fair_break(8).each_slice(8/2){|round| p round }
    # Output:
    #    [[0, 7], [6, 1], [2, 5], [4, 3]]
    #    [[1, 7], [0, 2], [3, 6], [5, 4]]
    #    [[7, 2], [1, 3], [4, 0], [6, 5]]
    #    [[3, 7], [2, 4], [5, 1], [0, 6]]
    #    [[7, 4], [3, 5], [6, 2], [1, 0]]
    #    [[5, 7], [4, 6], [0, 3], [2, 1]]
    #    [[7, 6], [5, 0], [1, 4], [3, 2]]
    #
    # If no block is given, returns a new Enumerator that will enumerate with the pairs.
    #
    # Example 2:
    #    teams = %w(A B C D  E F G H)
    #    enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
    #           #=> #<Enumerator: SLSP::CircleMethod:each_with_fair_break(8)>
    #    enum.each_slice(teams.size/2).each_with_index do |x, i|
    #        puts "Round #{i}: " + x.map{|p,q| "#{teams[p]} vs #{teams[q]}"}.join(", ")
    #    end
    # Output:
    #    Round 0: A vs H, G vs B, C vs F, E vs D
    #    Round 1: B vs H, A vs C, D vs G, F vs E
    #    Round 2: H vs C, B vs D, E vs A, G vs F
    #    Round 3: D vs H, C vs E, F vs B, A vs G
    #    Round 4: H vs E, D vs F, G vs C, B vs A
    #    Round 5: F vs H, E vs G, A vs D, C vs B
    #    Round 6: H vs G, F vs A, B vs E, D vs C
    #
    # == Breaks
    # In Sports League Scheduling Problems, a break means
    # "two consecutive home matches or two consecutive away matches". 
    # In the following example,
    # team A, B, D, and F have "hh" (consecutive two home matches), and
    # team C, E, G, and H have "aa" (consecutive two away matches).
    # So, each team has one break fairly.
    #
    # Example 3:
    #    teams = %w(A B C D  E F G H)
    #    puts "Team   : " + teams.join(" ")
    #    enum = SLSP::CircleMethod.each_with_fair_break(teams.size)
    #    enum.each_slice(teams.size/2).each_with_index do |round, i|
    #        a = []
    #        round.each do |home, away|
    #            a[home] = "h"
    #            a[away] = "a"
    #        end
    #        puts "Round #{i}: " + a.join(" ")
    #    end
    # Output:
    #    Team   : A B C D E F G H
    #    Round 0: h a h a h a h a
    #    Round 1: h h a h a h a a
    #    Round 2: a h a a h a h h
    #    Round 3: h a h h a h a a
    #    Round 4: a h a h a a h h
    #    Round 5: h a h a h h a a
    #    Round 6: a h a h a h a h
    #
    def self.each_with_fair_break(n, &block)
      i = InternalUseOnly.convert_to_non_negative_int(n)
      unless block_given?
        return enum_for(__method__, i){ i*(i-1)/2 }
      end
      if i.even?
        InternalUseOnly.each_with_fair_break_of_even(i, &block)
      else
        InternalUseOnly.each_with_fair_break_of_odd(i, &block)
      end
      nil
    end
  end
end
