-- rp:Friends
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RP_FRIENDS     = RP_FRIENDS;

table.insert(RP_FRIENDS.startup, function(state) -- startup function
  local Utils      = RP_FRIENDS.utils;
  
  if not Utils.color then Utils.color = {} end;
  
  local Color = Utils.color;
  
  local Config     = Utils.config;
  local isnum      = Utils.text.isnum;
  
  -- HSV/RGB conversion function from
  -- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
  
  --[[
   * Converts an HSV color value to RGB. Conversion formula
   * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
   * Assumes h, s, and v are contained in the set [0, 1] and
   * returns r, g, and b in the set [0, 255].
   *
   * @param   Number  h       The hue
   * @param   Number  s       The saturation
   * @param   Number  v       The value
   * @return  Array           The RGB representation
  ]]
  local function hsvToRgb(h, s, v, a)
        local r, g, b
  
        local i = math.floor(h * 6);
        local f = h * 6 - i;
        local p = v * (1 - s);
        local q = v * (1 - f * s);
        local t = v * (1 - (1 - f) * s);
  
        i = i % 6
  
        if        i == 0 then r, g, b = v, t, p
           elseif i == 1 then r, g, b = q, v, p
           elseif i == 2 then r, g, b = p, v, t
           elseif i == 3 then r, g, b = p, q, v
           elseif i == 4 then r, g, b = t, p, v
           elseif i == 5 then r, g, b = v, p, q
        end
  
        return r * 255, g * 255, b * 255, a * 255
  
  end; 
  
        -- returns a hue value (for HSV color) based on the values of three numbers
  local function redToGreenHue(value, lowValue, highValue, optionalInvert)
  
       local GREEN = 120; -- degrees for the starting color of green in HSV
  
       -- these normalize the values so we don't get weird range errors
       if lowValue > highValue then local tempValue = highValue;
                                          highValue = lowValue;
                                          lowValue  = tempValue;
                                    end;
       if value    > highValue then       value     = highValue; end;
       if value    < lowValue  then       value     = lowValue; end; 
  
       local width =  highValue - lowValue;
       if    width == 0 then width = 1;end; -- because we divide by width below
  
       local valuePos      = value    - lowValue; -- position within width
       local valueFraction = valuePos / width;    -- fractional distance through width
  
       if not optionalInvert
          then return (GREEN/360) * valueFraction;
          else return (GREEN/360) - (GREEN/360) * valueFraction;
       end; -- if
  end; 
  
        -- function to take two values and return either COLOR_LESSTHAN, COLOR_GREATERTHAN, or COLOR_EQUALISH
  local function compareColor(firstValue, secondValue, isExact)
    
        if    not isnum(firstValue) 
           or not isnum(secondValue) 
           then return ""; end; -- don't change the color
  
        local sum      = math.abs(firstValue) + math.abs(secondValue);
        local sigma    = sum * 0.05;
  
        if not isExact then sigma = sigma *2; end;
  
        if math.abs(firstValue - secondValue) < sigma 
           then return "|cff" .. Config.get("COLOR_EQUALISH");
           elseif firstValue - secondValue > 0
                  then return "|cff" .. Config.get("COLOR_LESSTHAN");
           else return "|cff" .. Config.get("COLOR_GREATERTHAN");
           end; -- if
  end; 
  
  local function integerToHex(number) return string.format("%02", math.floor(number));   end;
  local function colorCode(r, g, b)   return string.format("|cff%02x%02x%02x", r, g, b); end;

  local function rgbToIntegers(rgb) if rgb:len() == 0 then return nil, nil, nil end;
    rgb = rgb:gsub("^|cff",""):gsub("^#",""); -- just in case
    if not rgb:match("^%x%x%x%x%x%x$") then return nil, nil, nil end;
    return tonumber(rgb:sub(1, 2), 16), tonumber(rgb:sub(3, 4), 16), tonumber(rgb:sub(5, 6), 16); -- 16 = base 16 (hexadecimal)
  end; -- function
  
  local function ico(path, tint, param) if not path then return "" end;
    if     not param            then param = RP_FRIENDS.const.icons.PARAMS.DEFAULT
    elseif RP_FRIENDS.const.icons.PARAMS[param] ~= nil then param = RP_FRIENDS.const.icons.PARAMS[param]
                                else param = RP_FRIENDS.const.icons.PARAMS.DEFAULT  end; -- if not param
    local val = "|TInterface\\" .. path .. ":" .. param;
    if tint then local r, g, b = rgbToIntegers(tint); val = val..":"..r..":"..g..":"..b; end; -- if tint
    val = val .. "|t";
    return val;
  end; -- function

  local function hexaToFloat(rgb) r, g, b = rgbToIntegers(rgb); return r and r / 255 or 0, g and g / 255 or 0, b and b / 255 or 0 end;

  -- Utilities available via RP_FRIENDS.utils.color
  --
  Color.colorCode      = colorCode;      -- replace
  Color.compare        = compareColor;
  Color.numberToHexa   = integerToHex;
  Color.hsvToRgb       = hsvToRgb;
  Color.redToGreenHue  = redToGreenHue;
  Color.hexaToNumber   = rgbToIntegers;
  Color.ico            = ico;
  Color.hexaToFloat    = hexaToFloat;

  return "utils-color";
end); -- startup function
