import crypt

print(crypt.mksalt(crypt.METHOD_SHA512), file=sys.stdout)
