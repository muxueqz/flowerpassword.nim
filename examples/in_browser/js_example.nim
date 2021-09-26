from flowerpassword import huami

when defined(js):
  proc generate_password*(password, key: cstring): cstring {.exportc.} =
    echo [key, password]
    var (result, _) = huami($password, $key)
    return result
