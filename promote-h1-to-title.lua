local title

-- Promote all headers by one level. Set title from level 1 headers,
-- unless it has been set before.
function promote_header (header)

  if header.level >= 2 then
    return header
  end

  if not title then
    title = header.content
    return nil
  end

  local msg = '[WARNING] title already set; demoting header "%s"\n'
  io.stderr:write(msg:format(pandoc.utils.stringify(header)))
  header.level = header.level + 1
  return header
end

return {
  {Meta = function (meta) title = meta.title end}, -- init title
  {Header = promote_header},
  {Meta = function (meta) meta.title = title; return meta end}, -- set title
}
