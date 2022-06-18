import std/options, ../../json_serialization/[reader, writer, lexer]
export options

template writeField*(w: var JsonWriter,
                     record: auto,
                     fieldName: static string,
                     field: Option) =
  mixin writeField

  if field.isSome:
    writeField(w, record, fieldName, field.get)

proc writeValue*(writer: var JsonWriter, value: Option) =
  mixin writeValue

  if value.isSome:
    writer.writeValue value.get
  else:
    writer.writeValue JsonString("null")

proc readValue*[T](reader: var JsonReader, value: var Option[T]) =
  mixin readValue

  let tok = reader.lexer.lazyTok
  if tok == tkNull:
    reset value
    reader.lexer.next()
  else:
    value = some reader.readValue(T)
