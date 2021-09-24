import std/strutils

var
  huami_key, password: string
const
  STR1 = "snow"
  STR2 = "kise"
  STR3 = "sunlovesnow1990090127xykab"

when defined(js):
  proc md5*(key, password: cstring): cstring {.importc: "md5".}
else:
  import hmac
  import parseopt
  proc md5*(key, password: string): string =
    return hmac_md5(key, password).toHex()


proc huami*(password, key: string): (string, string) =
    # 得到md5one, md5two, md5three
    # hmac.new(key, msg)
    var
      md5one = md5(key, password)
      md5two = md5(STR1, md5one)
      md5three = md5(STR2, md5one)
      code16: string
    # # 转换大小写
    var
      rule = md5three
      source: array[32, char]
    # for i in range(0, 32):
    for i in 0..31:
      if rule[i] in STR3:
        source[i] = toUpperAscii(md5two[i])
      else:
        source[i] = md5two[i]
        # source[i] = "x"
    #保证密码首字母为字母---why?
    if source[0].isDigit():
      code16 = join(["K", source[1..15].join()])
    else:
        # code16 = "".join(source[0:16])
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

when defined(js):
  proc generate_password*(password, key: string): cstring {.exportc.} =
    var (result, _) = huami(password, key)
    return result
