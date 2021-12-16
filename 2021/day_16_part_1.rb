# frozen_string_literal: true

raw_message = DATA.readline.strip

# Find the binary length of the message
# Must be a better way of this?
$binary_length = ("F" * raw_message.length).to_i(16).to_s(2).length

$message = raw_message.to_i(16)

# puts format("%0#{$binary_length}b", $message)

def shift_message(bits)
  out = $message >> ($binary_length - bits)
  $message -= (out << ($binary_length - bits))
  $binary_length -= bits
  out
end

def literal_type
  literal = ""
  loop do
    part = shift_message(5)

    label = part & 0b10000
    literal += format("%04b", (part - label))

    break if label == 0
  end

  literal.to_i(2)
end

def operator_type
  length_id = shift_message(1)
  parts = []

  if length_id == 0
    length = shift_message(15)

    position = $binary_length
    loop do
      parts << message

      break if position - $binary_length == length
    end
  else
    count = shift_message(11)

    loop do
      parts << message

      break if parts.length == count
    end
  end

  parts
end

def message
  version = shift_message(3)
  type = shift_message(3)
  value = if type == 4
            literal_type
          else
            operator_type
          end
  {
    version: version,
    type: type,
    value: value
  }
end

decoded = message

def version_sum(decoded)
  return decoded[:version] if decoded[:value].is_a?(Integer)

  decoded[:version] + decoded[:value].map { |d| version_sum(d) }.sum
end

puts version_sum(decoded)

__END__
220D6448300428021F9EFE668D3F5FD6025165C00C602FC980B45002A40400B402548808A310028400C001B5CC00B10029C0096011C0003C55003C0028270025400C1002E4F19099F7600142C801098CD0761290021B19627C1D3007E33C4A8A640143CE85CB9D49144C134927100823275CC28D9C01234BD21F8144A6F90D1B2804F39B972B13D9D60939384FE29BA3B8803535E8DF04F33BC4AFCAFC9E4EE32600C4E2F4896CE079802D4012148DF5ACB9C8DF5ACB9CD821007874014B4ECE1A8FEF9D1BCC72A293A0E801C7C9CA36A5A9D6396F8FCC52D18E91E77DD9EB16649AA9EC9DA4F4600ACE7F90DFA30BA160066A200FC448EB05C401B8291F22A2002051D247856600949C3C73A009C8F0CA7FBCCF77F88B0000B905A3C1802B3F7990E8029375AC7DDE2DCA20C2C1004E4BE9F392D0E90073D31634C0090667FF8D9E667FF8D9F0C01693F8FE8024000844688FF0900010D8EB0923A9802903F80357100663DC2987C0008744F8B5138803739EB67223C00E4CC74BA46B0AD42C001DE8392C0B0DE4E8F660095006AA200EC198671A00010E87F08E184FCD7840289C1995749197295AC265B2BFC76811381880193C8EE36C324F95CA69C26D92364B66779D63EA071008C360098002191A637C7310062224108C3263A600A49334C19100A1A000864728BF0980010E8571EE188803D19A294477008A595A53BC841526BE313D6F88CE7E16A7AC60401A9E80273728D2CC53728D2CCD2AA2600A466A007CE680E5E79EFEB07360041A6B20D0F4C021982C966D9810993B9E9F3B1C7970C00B9577300526F52FCAB3DF87EC01296AFBC1F3BC9A6200109309240156CC41B38015796EABCB7540804B7C00B926BD6AC36B1338C4717E7D7A76378C85D8043F947C966593FD2BBBCB27710E57FDF6A686E00EC229B4C9247300528029393EC3BAA32C9F61DD51925AD9AB2B001F72B2EE464C0139580D680232FA129668
