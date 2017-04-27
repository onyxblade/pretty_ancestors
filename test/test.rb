require '../lib/pretty_ancestors'
require 'minitest/autorun'
require 'pp'

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

    assert_equal [[[[clean_room::M1], clean_room::M2, []]], clean_room::M3, []], clean_room::M3.pretty_ancestors
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors.flatten
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

    assert_equal [[], clean_room::M3, [[[], clean_room::M2, [clean_room::M1]]]], clean_room::M3.pretty_ancestors
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors.flatten
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

    assert_equal [[], clean_room::M3, [[[clean_room::M1], clean_room::M2, []]]], clean_room::M3.pretty_ancestors
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors.flatten
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

    assert_equal [[[[], clean_room::M2, [clean_room::M1]]], clean_room::M3, []], clean_room::M3.pretty_ancestors
    assert_equal clean_room::M3.ancestors, clean_room::M3.pretty_ancestors.flatten
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