import std/strutils

var
  huami_key, password: string
const
  STR1 = "snow"
  STR2 = "kise"
  STR3 = "sunlovesnow1990090127xykab"

when defined(js):
  proc md5(key, password: cstring): cstring {.importc: "md5".}
  proc md5hex(key, password: cstring): cstring =
    return md5(password, key)
else:
  import hmac
  import parseopt
  proc md5hex(key, password: string): string =
    return hmac_md5(key, password).toHex()


proc huami*(password, key: string): (string, string) =
    # 得到md5one, md5two, md5three
    var
      md5one = md5hex(key, password)
      md5two = md5hex(STR1, md5one)
      md5three = md5hex(STR2, md5one)
      code16: string
      rule = md5three
      source: array[32, char]
    # 转换大小写
    for i in 0..31:
      if rule[i] in STR3:
        source[i] = toUpperAscii(md5two[i])
      else:
        source[i] = md5two[i]
    #保证密码首字母为字母---why?
    if source[0].isDigit():
      code16 = join(["K", source[1..15].join()])
    else:
      code16 = source[0..15].join()
    return (code16, source.join())

when isMainModule:
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

  var (r, _) = huami(password, huami_key)
  echo r
