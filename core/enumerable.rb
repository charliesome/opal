module Enumerable
  def all?(&block)
    %x{
      var result = true, proc;

      if (block !== nil) {
        proc = function(obj) {
          var value;

          if ((value = block.call(__context, obj)) === __breaker) {
            return __breaker.$v;
          }

          if (value === false || value === nil) {
            result = false;
            __breaker.$v = nil;

            return __breaker;
          }
        }
      }
      else {
        proc = function(obj) {
          if (obj === false || obj === nil) {
            result = false;
            __breaker.$v = nil;

            return __breaker;
          }
        }
      }

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def any?(&block)
    %x{
      var result = false, proc;

      if (block !== nil) {
        proc = function(obj) {
          var value;

          if ((value = block.call(__context, obj)) === __breaker) {
            return __breaker.$v;
          }

          if (value !== false && value !== nil) {
            result       = true;
            __breaker.$v = nil;

            return __breaker;
          }
        }
      }
      else {
        proc = function(obj) {
          if (obj !== false && obj !== nil) {
            result      = true;
            __breaker.$v = nil;

            return __breaker;
          }
        }
      }

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def collect(&block)
    %x{
      var result = [];

      var proc = function() {
        var obj = __slice.call(arguments), value;

        if ((value = block.apply(__context, obj)) === __breaker) {
          return __breaker.$v;
        }

        result.push(value);
      };

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def count(object, &block)
    %x{
      var result = 0;

      if (object != null) {
        block = function(obj) { return #{ `obj` == `object` }; };
      }
      else if (block === nil) {
        block = function() { return true; };
      }

      var proc = function(obj) {
        var value;

        if ((value = block.call(__context, obj)) === __breaker) {
          return __breaker.$v;
        }

        if (value !== false && value !== nil) {
          result++;
        }
      }

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def detect(ifnone, &block)
    %x{
      var result = nil;

      #{self}.$each._p = function(obj) {
        var value;

        if ((value = block.call(__context, obj)) === __breaker) {
          return __breaker.$v;
        }

        if (value !== false && value !== nil) {
          result      = obj;
          __breaker.$v = nil;

          return __breaker;
        }
      };

      #{self}.$each();

      if (result !== nil) {
        return result;
      }

      if (typeof(ifnone) === 'function') {
        return #{ ifnone.call };
      }

      return ifnone == null ? nil : ifnone;
    }
  end

  def drop(number)
    %x{
      var result  = [],
          current = 0;

      #{self}.$each._p = function(obj) {
        if (number < current) {
          result.push(e);
        }

        current++;
      };

      #{self}.$each();

      return result;
    }
  end

  def drop_while(&block)
    %x{
      var result = [];

      #{self}.$each._p = function(obj) {
        var value;

        if ((value = block.call(__context, obj)) === __breaker) {
          return __breaker;
        }

        if (value === false || value === nil) {
          result.push(obj);
          return value;
        }
        
        
        return __breaker;
      };

      #{self}.$each();

      return result;
    }
  end

  def each_with_index(&block)
    %x{
      var index = 0;

      #{self}.$each._p = function(obj) {
        var value;

        if ((value = block.call(__context, obj, index)) === __breaker) {
          return __breaker.$v;
        }

        index++;
      };

      #{self}.$each();

      return nil;
    }
  end

  def each_with_object(object, &block)
    %x{
      #{self}.$each._p = function(obj) {
        var value;

        if ((value = block.call(__context, obj, object)) === __breaker) {
          return __breaker.$v;
        }
      };

      #{self}.$each();

      return object;
    }
  end

  def entries
    %x{
      var result = [];

      #{self}.$each._p = function(obj) {
        result.push(obj);
      };

      #{self}.$each();

      return result;
    }
  end

  alias find detect

  def find_all(&block)
    %x{
      var result = [];

      #{self}.$each._p = function(obj) {
        var value;

        if ((value = block.call(__context, obj)) === __breaker) {
          return __breaker.$v;
        }

        if (value !== false && value !== nil) {
          result.push(obj);
        }
      };

      #{self}.$each();

      return result;
    }
  end

  def find_index(object, &block)
    %x{
      var proc, result = nil, index = 0;

      if (object != null) {
        proc = function (obj) { 
          if (#{ `obj` == `object` }) {
            result = index;
            return __breaker;
          }
          index += 1;
        };
      }
      else {
        proc = function(obj) {
          var value;

          if ((value = block.call(__context, obj)) === __breaker) {
            return __breaker.$v;
          }

          if (value !== false && value !== nil) {
            result     = index;
            __breaker.$v = index;

            return __breaker;
          }
          index += 1;
        };
      }

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def first(number)
    %x{
      var result = [],
          current = 0,
          proc;

      if (number == null) {
        result = nil;
        proc = function(obj) {
            result = obj; return __breaker;
          };
      } else {
        proc = function(obj) {
            if (number <= current) {
              return __breaker;
            }

            result.push(obj);

            current++;
          };
      }

      #{self}.$each._p = proc;
      #{self}.$each();

      return result;
    }
  end

  def grep(pattern, &block)
    %x{
      var result = [];

      #{self}.$each._p = (block !== nil
        ? function(obj) {
            var value = #{pattern === `obj`};

            if (value !== false && value !== nil) {
              if ((value = block.call(__context, obj)) === __breaker) {
                return __breaker.$v;
              }

              result.push(value);
            }
          }
        : function(obj) {
            var value = #{pattern === `obj`};

            if (value !== false && value !== nil) {
              result.push(obj);
            }
          });

      #{self}.$each();

      return result;
    }
  end

  alias select find_all

  alias take first

  alias to_a entries
end