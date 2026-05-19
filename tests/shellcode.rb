#    This file is part of Metasm, the Ruby assembly manipulation suite
#    Copyright (C) 2006-2009 Yoann GUILLOT
#
#    Licence is LGPL, see LICENCE in the top-level directory


require 'test/unit'
require 'metasm'

class TestShellcode < Test::Unit::TestCase
	@@cpu = Metasm::Ia32.new

	def assert_equal(a, b) super(b, a) end

	def bin(s)
		if s.respond_to?(:force_encoding)
			s.force_encoding('BINARY')
		else
			s
		end
	end

	def assemble(src)
		Metasm::Shellcode.assemble(@@cpu, src).encode_string
	end

	# ---- define_data ----

	def test_define_data_basic
		assert_equal(Metasm::Shellcode.define_data("ABCD".b), 'db 0x41, 0x42, 0x43, 0x44')
	end

	def test_define_data_empty
		assert_equal(Metasm::Shellcode.define_data("".b), '')
	end

	def test_define_data_nil
		assert_equal(Metasm::Shellcode.define_data(nil), '')
	end

	def test_define_data_full_range
		assert_equal(Metasm::Shellcode.define_data("\x00\x01\x9f\xa0\xff".b),
			'db 0x00, 0x01, 0x9f, 0xa0, 0xff')
	end

	def test_define_data_roundtrip_printable
		src = Metasm::Shellcode.define_data("ABCD".b)
		assert_equal(assemble(src), bin("ABCD"))
	end

	def test_define_data_roundtrip_full_range
		bytes = (0..255).map(&:chr).join.b
		src = Metasm::Shellcode.define_data(bytes)
		assert_equal(assemble(src), bin(bytes))
	end

	# ---- define_cstring ----

	def test_define_cstring_basic
		assert_equal(Metasm::Shellcode.define_cstring("ABCD".b), 'db "ABCD", 0')
	end

	def test_define_cstring_empty
		assert_equal(Metasm::Shellcode.define_cstring("".b), 'db 0')
	end

	def test_define_cstring_nil
		assert_equal(Metasm::Shellcode.define_cstring(nil), 'db 0')
	end

	def test_define_cstring_escape_quote
		assert_equal(Metasm::Shellcode.define_cstring("a\"b".b), 'db "a\"b", 0')
	end

	def test_define_cstring_escape_backslash
		# input: one backslash; expected output: backslash-backslash inside string literal
		assert_equal(Metasm::Shellcode.define_cstring("a\\b".b), 'db "a\\\\b", 0')
	end

	def test_define_cstring_mixed_printable_and_binary
		assert_equal(Metasm::Shellcode.define_cstring("AB\x05CD".b),
			'db "AB", 0x05, "CD", 0')
	end

	def test_define_cstring_single_high_byte
		assert_equal(Metasm::Shellcode.define_cstring("\xff".b), 'db 0xff, 0')
	end

	def test_define_cstring_roundtrip_printable
		src = Metasm::Shellcode.define_cstring("ABCD".b)
		assert_equal(assemble(src), bin("ABCD\x00"))
	end

	def test_define_cstring_roundtrip_with_binary
		input = "AB\x05CD".b
		src = Metasm::Shellcode.define_cstring(input)
		assert_equal(assemble(src), bin(input + "\x00"))
	end

	def test_define_cstring_roundtrip_escapes
		input = "a\"b\\c".b
		src = Metasm::Shellcode.define_cstring(input)
		assert_equal(assemble(src), bin(input + "\x00"))
	end

	def test_define_cstring_roundtrip_high_byte
		input = "\xff".b
		src = Metasm::Shellcode.define_cstring(input)
		assert_equal(assemble(src), bin(input + "\x00"))
	end
end
