import intsets
import parseopt
import std/sugar
from flowerpassword import huami

const
  lower = "abcdefghijklmnopqrstuvwxyz"
  upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  punctuation = ",.:;!?"
  number = "0123456789"
  alphabet = lower & upper & number & punctuation

proc seek_password*(hash: string): string =
  # generate alphabet
  # try to generate password
  for i in 0..(len(hash) - 10):
    var
      sub_hash = hash[i..i + 9]
      count = 0
      map_index = collect(newSeq):
        for c in sub_hash:
          count = (count + ord(c)) mod len(alphabet)
          count
      sk_pwd = ""
      match = initIntSet()
    for i in map_index:
      sk_pwd.add(alphabet[i])

    # validate password
    var match_list =  @[lower, upper, number, punctuation]
    for i in sk_pwd:
        for m in 0..len(match_list) - 1:
            if i in match_list[m]:
                match.incl(m)
    if len(match) == 4:
        return sk_pwd

  return ""

when isMainModule:
  var
    huami_key, password: string
  for kind, key, val in getopt():
    case kind
    of cmdArgument:
      discard
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        echo "Please use ./flowerpassword --key=KEY --password=PASSWORD"
        quit()
      of "key": huami_key = val
      of "password": password = val
    of cmdEnd: assert(false) # cannot happen

  var (_, r) = huami(password, huami_key)
  echo seek_password(r)
