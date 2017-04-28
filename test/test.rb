require '../lib/pretty_ancestors'
require 'minitest/autorun'

class TestPrettyAncestors < Minitest::Test

  def test_prepend_prepend
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
        prepend M1
      end

      module M3
        prepend M2
      end
    EOF

    assert_equal [[[[clean_room::M1], clean_room::M2]], clean_room::M3], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_include_include
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
        include M1
      end

      module M3
        include M2
      end
    EOF

    assert_equal [clean_room::M3, [[clean_room::M2, [clean_room::M1]]]], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_include_prepend
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
        prepend M1
      end

      module M3
        include M2
      end
    EOF

    assert_equal [clean_room::M3, [[[clean_room::M1], clean_room::M2]]], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_prepend_include
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
        include M1
      end

      module M3
        prepend M2
      end
    EOF

    assert_equal [[[clean_room::M2, [clean_room::M1]]], clean_room::M3], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_include_twice
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
      end

      module M3
        include M1
        include M2
      end
    EOF

    assert_equal [clean_room::M3, [clean_room::M2, clean_room::M1]], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_prepend_twice
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
      end

      module M3
        prepend M1
        prepend M2
      end
    EOF

    assert_equal [[clean_room::M2, clean_room::M1], clean_room::M3], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_class
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
        include M1
      end

      module M3
      end

      module M4
        prepend M3
      end

      module M5
      end

      class C
        include M4
        include M2
        prepend M5
      end
    EOF

    assert_equal [[clean_room::M5], clean_room::C, [[clean_room::M2, [clean_room::M1]], [[clean_room::M3], clean_room::M4]]], clean_room::C.pretty_ancestors(:simplified)[0]
    assert_equal Object, clean_room::C.pretty_ancestors(:simplified)[1][0]
    assert_includes clean_room::C.pretty_ancestors(:simplified)[1][1], Kernel
    assert_equal BasicObject, clean_room::C.pretty_ancestors(:simplified)[2]
    assert_equal clean_room::C.ancestors, clean_room::C.pretty_ancestors(:simplified).flatten
  end

  def test_include_later
    clean_room = build_clean_room <<-EOF
      module M1
      end

      module M2
      end

      module M3
        include M2
      end

      module M2
        include M1
      end
    EOF

    assert_equal [clean_room::M3, [clean_room::M2]], clean_room::M3.pretty_ancestors(:simplified)
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors(:simplified).flatten
  end

  def test_single_module
    clean_room = build_clean_room <<-EOF
      module M
      end
    EOF

    assert_equal [clean_room::M], clean_room::M.pretty_ancestors(:simplified)
  end

  def build_clean_room code
    rand = Random.rand(1000000)
    eval <<-EOF
      module CleanRoom#{rand}
        #{code}
      end
    EOF
    eval "CleanRoom#{rand}"
  end
end