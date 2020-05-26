#shellcheck shell=sh

Describe "Sample spec-file"
#  Describe "hello()"
#    hello() {
#      echo # "hello $1"
#    }
#
#    It "puts greeting, but not implemented"
#      Pending "You should implement hello function"
#      When call hello world
#      The output should eq "hello world"
#    End
#  End

  Describe "hello()"
    Include lib/function.sh

    It "puts greeting"
      When call hello friend
      The output should eq "Hello friend."
    End
  End
End
