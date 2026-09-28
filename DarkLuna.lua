--[[
	LUNA DARK UI 
	Misma API que la libreria original, con el look oscuro plano de las capturas:
	fondo #0D0C0F, superficies de un solo tono, lineas de 1px, sin radios, sin
	gradientes ni destellos. Un solo archivo, sin assets externos,
	0 loops por frame (solo eventos + tweens).

	ES COMPATIBLE CON LocalScript Y CON EXECUTORS (Lua 5.1 / LuaJIT):
	no usa +=, continue, //, goto, math.clamp, math.round, table.clear, table.clone
	ni task.delay (si no existe task usa spawn/wait), y si no hay PlayerGui cae a CoreGui.
	En executors la libreria queda en getgenv().LunaDarkUI.

	CARGA:
		LocalScript: local lib = require(script.Parent.LunaDark)
		Executor con loadfile: local lib = loadfile("LunaDark.lua")()
		Executor con readfile/loadstring: local lib = loadstring(readfile("LunaDark.lua"))()
		Desde GitHub: local lib = (loadstring or load)(game:HttpGet(URL))()

	OJO: cargar la libreria NO dibuja nada. Hay que crear la ventana despues:
		local lib = (loadstring or load)(game:HttpGet(URL))()
		local win = lib:CreateWindow{ Title = "LUNA" }   -- <- esto es lo que se ve

	EJEMPLO:
	LOOK DE LAS CAPTURAS: se aplica antes de crear la ventana, asi las filas ya
	nacen con su alto final.
		lib:Theme("Sombra")
		lib:Style("Linea")

		local win = lib:CreateWindow{
			Title = "LUNA", Subtitle = "DARK UI", RestoreButtonText = "MENU",
			Width = 800, Height = 600,   -- referencia equilibrada para la UI
			StatusText = "listo",        -- franja de estado en el borde inferior
			Keybind = Enum.KeyCode.RightControl,
		}
		local tab = win:AddTab("Principal")
		tab:SetSubtitle("Opciones basicas")   -- la linea bajo la barra
		local sec = tab:AddSection("Opciones")

		sec:AddToggle("Aura",    { Default = false, Callback = function(v) end })
		sec:AddSlider("Velocidad", { Min = 0, Max = 100, Default = 50, Suffix = "%" })
		sec:AddInput("Usuario", { Placeholder = "nombre..." })
		sec:AddButton("Ejecutar", function() print("go") end)
		sec:AddDropdown("Modo", { Options = {"A","B","C"}, Default = "A" })
		sec:AddDropdown("Modo", {"A","B","C"}, "A", function(v) end)   -- firma antigua
		sec:AddProgress("Carga", { Default = 40 })
		sec:AddKeybind("Bindeo")
		sec:AddCheckbox("Casilla", { Default = true })
		sec:AddCombobox("Buscar", { Options = {"a","b"}, Default = "a" })  -- con buscador
		sec:AddButtonGroup("Modo", { Options = {"1","2","3"}, Default = "2" })
		sec:AddTextArea("Notas", { Default = "texto", Height = 70 })
		sec:AddColorPicker("Acento", { Apply = true })   -- Apply = cambia el tema
		sec:AddInfo({ Title = "Aviso", Text = "texto\nmultilinea" })
		sec:AddToggle("Ayuda"):Tooltip("Se explica al pasar el raton")

		win:SetKeybind(Enum.KeyCode.RightControl) -- reemplaza LShift predeterminado
		win:SetStatusText("ahora: " .. os.time())  -- anade la franja si no habia StatusText
		win:Search("velocidad")  -- filtra las filas de la tab activa; "" = todas
		win:Snap("Left")         -- Left / Right / Top / Bottom / Center
		win:Resize(800, 600)
		win:SetRadius(2)         -- radio SOLO de esta ventana; nil = el del estilo
		win:SetTransparency(0)   -- 0 solida, 1 invisible
		win:Animate(false)       -- cerrar con animacion
		lib:Notify{ Title = "Listo", Text = "UI cargada", Type = "success" }
		lib:Theme("Violeta")      -- color: Noir / Violeta / Ambar / Acero / Carmesi / Hueso / Sombra / Grafito, o tabla
		lib:Style("Linea")        -- aspecto: Linea / Plano / Contorno / Solido / Minimo / Foto / Amplia / Brutal / Cristal
		lib:GetStyle()            -- estado actual del estilo
		lib:GetFPS()              -- fotogramas por segundo
		lib:GetPing()             -- ping en ms
		lib:GetPlayerCount()      -- jugadores actuales
		lib:ClearToasts()         -- cierra todos los avisos
		lib.Config.Debug = true   -- imprime que propiedad no se pudo asignar (si la hay)
		lib:Unload()              -- limpia todo

	TEMAS (color): Noir (por defecto), Violeta, Ambar, Acero, Carmesi, Hueso,
		Sombra, Grafito, Ocean, Emerald, Rose, Arctic, Toxic, Midnight, Inferno y
		Monochrome. Los dos ultimos estan medidos sobre las capturas:
		fondo #0D0C0F, superficie #101012, bloque de cabecera #151419, lineas
		#0E0E10, separador #2F2E31, texto #A2A1A4 y apagado #565659.
	ESTILOS (aspecto, no color): Linea (el de las capturas: sin radios, sin
		relleno, lineas de 1px bajo cada fila, cabecera de pagina de 32px, filas
		de 20px y lateral de 34px), Plano (por defecto), Contorno, Solido,
		Minimo, Foto, Amplia (Linea con aire: filas a tamano natural y 12px
		de separacion), Brutal (solo wireframe) y Cristal (translucido).		Cada estilo trae Radio, Relleno de tarjeta, Borde, Hover, Pista,
		Alto de fila (RowScale), Separador, Densidad, Cabecera, Relleno de
		pestana y Separacion entre filas. Un estilo escrito a mano
		(lib:Style({ Radius = 0 })) parte de los valores por defecto. Al cambiar
		el estilo en caliente se actualizan color, bordes, radios, separadores,
		densidad, cabecera, alto de las filas y del lateral, sin recrear nada.
	ELEMENTOS: Button, Toggle, Slider, Input, Dropdown, Label, Progress, Keybind,
		Checkbox, Combobox, ButtonGroup, TextArea, ColorPicker, Info
		Los elementos se anaden a la pestana o a una seccion, con o sin tabla de opciones:
		sec:AddToggle("Aura", { Default = true })   ==   sec:AddToggle{ Name = "Aura", Default = true }

	CAMPOS DE LOS ELEMENTOS: todos devuelven la propia tabla y traen Frame. El
		control que hay que pulsar es api.Control, y lo tienen Button, Toggle,
		Checkbox, Dropdown, Keybind, Input, TextArea y Combobox. En el Combobox el
		Control es el boton que abre el menu; api.SearchBox es el filtro, que va
		dentro del menu. Slider, Progress, ButtonGroup, ColorPicker, Info y Label
		no tienen Control: se manejan con las referencias de su tipo. Ademas,
		segun el elemento:
		Input y TextArea: Changed (BindableEvent), Focus() y Blur();
		Toggle y Checkbox: TextLabel, Value, Toggle(); el rebote de 0.08s solo
		filtra el input real, nunca una llamada desde codigo;
		Combobox: SearchBox, OptionButtons, Search(texto) devuelve cuantos
		coinciden, Enter elige, Backspace borra del filtro;
		ButtonGroup: Buttons (cada uno con Frame y Value);
		Slider: Track, Fill y Knob; Progress: Track, Fill y Max en las opciones;
		ColorPicker: Swatch y HexBox; Info: TextLabel;
		Keybind: SetValue/GetValue.

	OPTIMIZACION: una sola conexion RenderStepped para toda la libreria (bombillo
	compartido) que se desconecta sola cuando no queda ninguna ventana, animaciones
	con TweenService en vez de bucles, y un unico marco de tooltip y de menus.
]]


--[[ COMPATIBILIDAD (LocalScript y executors: Lua 5.1 / LuaJIT / Luau) ]]
-- No usamos math.clamp, math.round, table.clear, table.clone, +=, continue ni //
-- porque no existen (o no parsean) en el Lua de la mayoria de executors.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Utils 100% Lua 5.1
local floor, min, max, abs = math.floor, math.min, math.max, math.abs

local function clamp(value, low, high)
	if value < low then
		return low
	elseif value > high then
		return high
	end
	return value
end

local function roundValue(value)
	return floor(value + 0.5)
end

local function clearTable(target)
	for key in pairs(target) do
		target[key] = nil
	end
end

local function copyTable(source)
	local result = {}
	for key, value in pairs(source) do
		result[key] = value
	end
	return result
end

-- Retrasos: task no existe en algunos executors
local defer = nil
if type(task) == "table" and type(task.delay) == "function" then
	defer = task.delay
else
	defer = function(seconds, callback)
		spawn(function()
			wait(seconds)
			callback()
		end)
	end
end

-- PlayerGui puede tardar en existir al inyectar; si no, usamos CoreGui
local function resolvePlayerGui()
	if not LocalPlayer then
		return nil
	end
	local existing = LocalPlayer:FindFirstChild("PlayerGui")
	if existing then
		return existing
	end
	local ok, waited = pcall(function()
		return LocalPlayer:WaitForChild("PlayerGui", 10)
	end)
	if ok and waited then
		return waited
	end
	return nil
end

local lib = {}
lib.__index = lib
lib.Version = ""
-- Huella: si el executor carga otra version, el numero no coincide con este.
lib.Build = "lunadark-1.4.0-b08-stats-themes"


--[[ CONFIG ]]--

local Config = {
	Accent = Color3.fromRGB(109, 61, 145),
	Accent2 = Color3.fromRGB(79, 41, 95),
	Background = Color3.fromRGB(13, 12, 15),
	Panel = Color3.fromRGB(18, 16, 20),
	Card = Color3.fromRGB(29, 26, 32),
	Stroke = Color3.fromRGB(51, 48, 53),
	Text = Color3.fromRGB(201, 198, 207),
	Muted = Color3.fromRGB(94, 100, 106),

	Font = Enum.Font.GothamSemibold,
	MonoFont = Enum.Font.Code,
	TextSize = 13,
	Radius = 4,
	Gutter = 10,
	RowPadding = 5,
	Anim = 0.16,
	BarHeight = 44,
	Sidebar = 168,
	Blur = false,
	Scanline = false,
	Debug = false,
	-- Ampliaciones
	StatusHeight = 7,
	ToastLimit = 4,
	Tooltips = true,
	Animations = true,
	RowScale = 1,
	Separator = false,
	Compact = false,
	-- Divisor: la linea clara de 1px que separa bloques (medida en #2F2E31).
	Divider = Color3.fromRGB(47, 46, 49),
	-- Densidad: factor de escala del contenido (1 = normal, 0.85 = compacto).
	Density = 1,
}

-- Todos los estilos comparten la misma base casi negra y solo cambian el acento
-- y el tono de los bordes, para que la UI se lea igual de apagada en todos.
local Themes = {
	Noir = {
		Accent = Color3.fromRGB(109, 61, 145),
		Accent2 = Color3.fromRGB(79, 41, 95),
		Background = Color3.fromRGB(13, 12, 15),
		Panel = Color3.fromRGB(18, 16, 20),
		Card = Color3.fromRGB(29, 26, 32),
		Stroke = Color3.fromRGB(51, 48, 53),
		Text = Color3.fromRGB(201, 198, 207),
		Muted = Color3.fromRGB(94, 100, 106),
	},
	Violeta = {
		Accent = Color3.fromRGB(147, 84, 214),
		Accent2 = Color3.fromRGB(107, 41, 145),
		Background = Color3.fromRGB(12, 10, 16),
		Panel = Color3.fromRGB(20, 16, 26),
		Card = Color3.fromRGB(32, 26, 42),
		Stroke = Color3.fromRGB(62, 48, 84),
		Text = Color3.fromRGB(212, 203, 226),
		Muted = Color3.fromRGB(112, 98, 134),
	},
	Ambar = {
		Accent = Color3.fromRGB(187, 148, 14),
		Accent2 = Color3.fromRGB(113, 78, 36),
		Background = Color3.fromRGB(15, 13, 10),
		Panel = Color3.fromRGB(22, 19, 14),
		Card = Color3.fromRGB(34, 30, 22),
		Stroke = Color3.fromRGB(62, 54, 36),
		Text = Color3.fromRGB(214, 205, 184),
		Muted = Color3.fromRGB(122, 110, 84),
	},
	Acero = {
		Accent = Color3.fromRGB(84, 116, 147),
		Accent2 = Color3.fromRGB(60, 84, 112),
		Background = Color3.fromRGB(11, 13, 16),
		Panel = Color3.fromRGB(16, 19, 24),
		Card = Color3.fromRGB(26, 30, 37),
		Stroke = Color3.fromRGB(48, 56, 68),
		Text = Color3.fromRGB(198, 205, 214),
		Muted = Color3.fromRGB(94, 104, 118),
	},
	Carmesi = {
		Accent = Color3.fromRGB(168, 40, 74),
		Accent2 = Color3.fromRGB(110, 26, 52),
		Background = Color3.fromRGB(15, 11, 12),
		Panel = Color3.fromRGB(22, 16, 18),
		Card = Color3.fromRGB(35, 25, 28),
		Stroke = Color3.fromRGB(66, 42, 48),
		Text = Color3.fromRGB(214, 194, 197),
		Muted = Color3.fromRGB(128, 100, 106),
	},
	Hueso = {
		Accent = Color3.fromRGB(169, 169, 169),
		Accent2 = Color3.fromRGB(110, 112, 118),
		Background = Color3.fromRGB(12, 12, 13),
		Panel = Color3.fromRGB(18, 18, 20),
		Card = Color3.fromRGB(28, 28, 31),
		Stroke = Color3.fromRGB(52, 52, 56),
		Text = Color3.fromRGB(214, 214, 216),
		Muted = Color3.fromRGB(118, 118, 124),
	},
	-- Sombra: los valores exactos medidos en las capturas (641x392 y 690x498).
	-- Fondo #0D0C0F, contenido #101012, bloque de cabecera #151419, lineas
	-- #0E0E10 y un divisor claro #2F2E31. Texto gris claro, nunca blanco puro.
	Sombra = {
		Accent = Color3.fromRGB(201, 200, 203),
		Accent2 = Color3.fromRGB(109, 108, 112),
		Background = Color3.fromRGB(13, 12, 15),
		Panel = Color3.fromRGB(16, 16, 18),
		Card = Color3.fromRGB(21, 20, 25),
		Stroke = Color3.fromRGB(14, 14, 16),
		Divider = Color3.fromRGB(47, 46, 49),
		Text = Color3.fromRGB(162, 161, 164),
		Muted = Color3.fromRGB(86, 86, 89),
	},
	-- Grafito: como Sombra pero con un punto frio y mas separacion.
	Grafito = {
		Accent = Color3.fromRGB(150, 168, 178),
		Accent2 = Color3.fromRGB(88, 104, 114),
		Background = Color3.fromRGB(13, 13, 15),
		Panel = Color3.fromRGB(14, 15, 17),
		Card = Color3.fromRGB(22, 24, 26),
		Stroke = Color3.fromRGB(18, 19, 21),
		Divider = Color3.fromRGB(52, 56, 60),
		Text = Color3.fromRGB(170, 174, 178),
		Muted = Color3.fromRGB(96, 100, 106),
	},
	Ocean = {
		Accent = Color3.fromRGB(52, 157, 204), Accent2 = Color3.fromRGB(28, 96, 132),
		Background = Color3.fromRGB(8, 14, 18), Panel = Color3.fromRGB(12, 21, 27),
		Card = Color3.fromRGB(19, 32, 40), Stroke = Color3.fromRGB(34, 62, 76),
		Text = Color3.fromRGB(196, 219, 228), Muted = Color3.fromRGB(91, 126, 141),
	},
	Emerald = {
		Accent = Color3.fromRGB(53, 184, 125), Accent2 = Color3.fromRGB(29, 113, 77),
		Background = Color3.fromRGB(8, 15, 12), Panel = Color3.fromRGB(12, 23, 18),
		Card = Color3.fromRGB(19, 34, 27), Stroke = Color3.fromRGB(35, 65, 51),
		Text = Color3.fromRGB(195, 222, 207), Muted = Color3.fromRGB(91, 128, 108),
	},
	Rose = {
		Accent = Color3.fromRGB(207, 91, 139), Accent2 = Color3.fromRGB(133, 47, 88),
		Background = Color3.fromRGB(17, 9, 14), Panel = Color3.fromRGB(26, 14, 21),
		Card = Color3.fromRGB(40, 22, 32), Stroke = Color3.fromRGB(73, 42, 59),
		Text = Color3.fromRGB(228, 204, 216), Muted = Color3.fromRGB(137, 101, 119),
	},
	Arctic = {
		Accent = Color3.fromRGB(115, 191, 224), Accent2 = Color3.fromRGB(67, 125, 156),
		Background = Color3.fromRGB(9, 13, 16), Panel = Color3.fromRGB(15, 21, 25),
		Card = Color3.fromRGB(24, 33, 39), Stroke = Color3.fromRGB(45, 61, 70),
		Text = Color3.fromRGB(211, 226, 232), Muted = Color3.fromRGB(112, 137, 148),
	},
	Toxic = {
		Accent = Color3.fromRGB(154, 204, 50), Accent2 = Color3.fromRGB(83, 124, 25),
		Background = Color3.fromRGB(11, 15, 8), Panel = Color3.fromRGB(17, 23, 12),
		Card = Color3.fromRGB(27, 36, 18), Stroke = Color3.fromRGB(51, 69, 31),
		Text = Color3.fromRGB(211, 224, 190), Muted = Color3.fromRGB(119, 139, 90),
	},
	Midnight = {
		Accent = Color3.fromRGB(93, 112, 224), Accent2 = Color3.fromRGB(52, 64, 142),
		Background = Color3.fromRGB(7, 8, 16), Panel = Color3.fromRGB(11, 13, 24),
		Card = Color3.fromRGB(19, 22, 38), Stroke = Color3.fromRGB(36, 41, 69),
		Text = Color3.fromRGB(203, 208, 232), Muted = Color3.fromRGB(96, 104, 139),
	},
	Inferno = {
		Accent = Color3.fromRGB(224, 91, 45), Accent2 = Color3.fromRGB(143, 47, 28),
		Background = Color3.fromRGB(16, 9, 7), Panel = Color3.fromRGB(25, 14, 11),
		Card = Color3.fromRGB(39, 22, 17), Stroke = Color3.fromRGB(72, 40, 30),
		Text = Color3.fromRGB(230, 210, 202), Muted = Color3.fromRGB(142, 105, 91),
	},
	Monochrome = {
		Accent = Color3.fromRGB(232, 232, 232), Accent2 = Color3.fromRGB(142, 142, 142),
		Background = Color3.fromRGB(10, 10, 10), Panel = Color3.fromRGB(16, 16, 16),
		Card = Color3.fromRGB(25, 25, 25), Stroke = Color3.fromRGB(55, 55, 55),
		Text = Color3.fromRGB(222, 222, 222), Muted = Color3.fromRGB(112, 112, 112),
	},

}

lib.Config = Config
lib.Themes = Themes

local themeLookup = {}
for name, values in pairs(Themes) do
	themeLookup[string.lower(name)] = values
end

--[[ UTILIDADES ]]--

local function warnProperty(class, key, message)
	if Config.Debug then
		print("[LunaDarkUI] " .. class .. "." .. tostring(key) .. ": " .. tostring(message))
	end
end

local function warnElement(kind, message)
	print("[LunaDarkUI] Add" .. kind .. " no se pudo crear: " .. tostring(message))
end

local function new(class, properties, parent)
	local object = Instance.new(class)
	if properties then
		for key, value in pairs(properties) do
			-- pcall: si una version de Roblox/executor no soporta la propiedad,
			-- la libreria debe seguir viva en vez de abortar toda la UI
			local ok, message = pcall(function()
				object[key] = value
			end)
			if not ok then
				warnProperty(class, key, message)
			end
		end
	end
	if parent then
		object.Parent = parent
	end
	return object
end

local tweenCache = {}

local function tweenInfo(seconds, style, direction)
	seconds = seconds or Config.Anim
	style = style or Enum.EasingStyle.Quint
	direction = direction or Enum.EasingDirection.Out
	local key = seconds .. "/" .. style.Name .. "/" .. direction.Name
	local cached = tweenCache[key]
	if not cached then
		cached = TweenInfo.new(seconds, style, direction)
		tweenCache[key] = cached
	end
	return cached
end

local function tween(object, properties, seconds, style, direction)
	local animation = TweenService:Create(object, tweenInfo(seconds, style, direction), properties)
	animation:Play()
	return animation
end

local function lighten(color, amount)
	return Color3.new(
		math.min(1, color.R + amount),
		math.min(1, color.G + amount),
		math.min(1, color.B + amount)
	)
end

local function formatNumber(value)
	if value % 1 == 0 then
		return tostring(value)
	end
	local text = string.format("%.2f", value)
	local trimmed = text:gsub("0+$", "")
	return (trimmed:gsub("%.$", ""))
end

local function pointerPosition(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		return Vector2.new(input.Position.X, input.Position.Y)
	end
	local mouse = UserInputService:GetMouseLocation()
	return Vector2.new(mouse.X, mouse.Y)
end

local function inside(guiObject, position)
	local origin = guiObject.AbsolutePosition
	local size = guiObject.AbsoluteSize
	return position.X >= origin.X
		and position.X <= origin.X + size.X
		and position.Y >= origin.Y
		and position.Y <= origin.Y + size.Y
end

local function beginDrag(onMove, onEnd)
	local moveConnection
	moveConnection = UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			if onMove then
				onMove(input)
			end
		end
	end)
	local endConnection
	endConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			moveConnection:Disconnect()
			endConnection:Disconnect()
			if onEnd then
				onEnd()
			end
		end
	end)
	return function()
		moveConnection:Disconnect()
		endConnection:Disconnect()
	end
end

--[[ REGISTRO DE TINTE (para lib:Theme en vivo) ]]--

local tint = {
	Accent = {},
	Card = {},
	Stroke = {},
	Text = {},
	Muted = {},
	Panel = {},
	Background = {},
}

local function tag(role, object)
	local list = tint[role]
	if list then
		table.insert(list, object)
	end
	return object
end

-- Valor original de cada boton de opcion (un numero, un Color3, lo que sea).
-- NO puede ir como campo del boton: una Instance de Roblox no admite miembros
-- nuevos. Claves debiles para no retener los botones que se destruyen al
-- rehacer la lista.
local optionValues = setmetatable({}, { __mode = "k" })

local function rememberOption(object, value)
	optionValues[object] = value
	return object
end

local function optionValue(object)
	if not object then
		return nil
	end
	return optionValues[object]
end

--[[ ESTILOS (la capa de aspecto, independiente del color) ]]
-- Un estilo decide radios, relleno de las tarjetas, fuerza del borde y lo que
-- sube el color al pasar el raton. Se puede cambiar en caliente con lib:Style().
-- Los valores por defecto son los de Plano: al aplicar un estilo que no
-- declare una clave (o al escribir uno a mano, lib:Style({ Radius = 0 })) esa
-- clave vuelve a su valor por defecto en vez de heredar la del estilo anterior.
local StyleDefaults = {
	RowPadding = 6,
	Radius = 4,
	CardTransparency = 0,
	StrokeTransparency = 0.25,
	Hover = 0.045,
	TrackTransparency = 0.6,
	RowScale = 1,
	Separator = false,
	Density = 1,
	Header = false,
	TabFill = 0.2,
}

local StylePresets = {
	-- Plano: el aspecto base de la libreria. Tarjeta opaca, borde 1px suave,
	-- esquinas cortas. Es el valor por defecto de todos los campos que un
	-- estilo puede omitir; el que reproduce las capturas es Linea.
	Plano = {
		RowPadding = 6,
		Radius = 4,
		CardTransparency = 0,
		StrokeTransparency = 0.25,
		Hover = 0.045,
		TrackTransparency = 0.6,
		RowScale = 1,
		Separator = false,
	},
	-- Contorno: sin relleno, solo lineas. Para menus muy sobrios.
	Contorno = {
		RowPadding = 4,
		Radius = 0,
		CardTransparency = 0.6,
		StrokeTransparency = 0.08,
		Hover = 0.03,
		TrackTransparency = 0.75,
		RowScale = 0.94,
		Separator = true,
	},
	-- Solido: mas contraste, esquinas marcadas, bordes casi invisibles.
	Solido = {
		RowPadding = 6,
		Radius = 6,
		CardTransparency = 0,
		StrokeTransparency = 0.6,
		Hover = 0.07,
		TrackTransparency = 0.5,
		RowScale = 1.06,
		Separator = false,
	},
	-- Minimo: sin relleno, sin bordes, solo tipografia y el acento.
	Minimo = {
		RowPadding = 6,
		Radius = 2,
		CardTransparency = 1,
		StrokeTransparency = 1,
		Hover = 0.02,
		TrackTransparency = 0.85,
		RowScale = 1,
		Separator = false,
	},
	-- Foto: sin esquinas, relleno de tarjeta muy tenue, una linea de 1px bajo
	-- cada fila y filas algo mas compactas. Linea es la version medida.
	Foto = {
		RowPadding = 4,
		Radius = 0,
		CardTransparency = 0.45,
		StrokeTransparency = 0.62,
		Hover = 0.07,
		TrackTransparency = 0.8,
		RowScale = 0.86,
		Separator = true,
	},
	-- Linea: el aspecto real de las capturas. Sin esquinas, sin relleno, sin
	-- bordes, una linea de 1px bajo cada fila, filas de ~20px, tipografia
	-- reducida y un bloque de cabecera de 32px con fondo propio.
	Linea = {
		RowPadding = 1,
		Radius = 0,
		-- 1 = sin relleno. La cabecera de pagina si conserva su bloque porque no
		-- se registra como tarjeta de estilo.
		CardTransparency = 1,
		StrokeTransparency = 1,
		Hover = 0.05,
		TrackTransparency = 0.85,
		RowScale = 0.62,
		Separator = true,
		Density = 0.85,
		Header = true,
		TabFill = 1,
	},
	-- Amplia: la version con aire de Linea. Filas a tamano natural (o un poco
	-- mas), 12px de hueco entre ellas, tarjeta opaca y esquinas cortas, para
	-- listas largas de elementos donde Linea se lee demasiado apretado.
	Amplia = {
		-- Espaciada, pero pensada para 800x600 y con tarjetas compactas.
		RowPadding = 5,
		Radius = 4,
		CardTransparency = 0,
		StrokeTransparency = 0.3,
		Hover = 0.05,
		TrackTransparency = 0.7,
		RowScale = 1.05,
		Separator = true,
		Density = 1,
		Header = true,
		TabFill = 0.2,
	},
	-- Brutal: puro Wireframe, esquinas a 0 y bordes marcados.
	Brutal = {
		RowPadding = 6,
		Radius = 0,
		CardTransparency = 0,
		StrokeTransparency = 0,
		Hover = 0.14,
		TrackTransparency = 0.35,
		RowScale = 1.1,
		Separator = true,
	},
	-- Cristal: superficies translucidas y esquinas amplias.
	Cristal = {
		RowPadding = 6,
		Radius = 8,
		CardTransparency = 0.62,
		StrokeTransparency = 0.35,
		Hover = 0.05,
		TrackTransparency = 0.7,
		RowScale = 1.06,
		Separator = false,
	},
}

local styleState = copyTable(StylePresets.Plano)
-- Campos que un preset puede no declarar: se rellenan con los valores por
-- defecto para que applyStyle nunca lea nil.
for key, value in pairs(StyleDefaults) do
	if styleState[key] == nil then
		styleState[key] = value
	end
end
Config.Radius = styleState.Radius

local styleLookup = {}
for name, values in pairs(StylePresets) do
	styleLookup[string.lower(name)] = values
end

lib.Styles = StylePresets

-- Tarjetas que nace opacas (las unicas que el estilo puede volver traslucidas).
local styleTargets = {}
-- Esquinas que siguen a Config.Radius (las que se crean sin radio explicito).
-- Entradas { Corner, Window, Radius }: el radio por ventana vive en la tabla,
-- nunca como campo de la Instance.
local roundTargets = {}
-- Lineas de 1px bajo las filas, activas solo en estilos con Separator.
local rowSeparators = {}
-- UIScale de densidad, uno por region de ventana (barra, lateral, contenido).
local densityTargets = {}
-- Bloques de cabecera de pagina, visibles solo en estilos con Header.
local headerBlocks = {}
-- UIListLayout de las filas, para cambiar el hueco entre ellas en caliente.
local layoutTargets = {}
-- Items del lateral: su alto y su texto siguen a la densidad del estilo. Se
-- guardan aparte porque un UIScale en el lateral moveria el divisor de 1px y
-- dejaria un hueco muerto a la derecha.
local tabItems = {}
-- Filas con alto fijo, para que un cambio de estilo en caliente tambien las
-- compacte (el contenido usa UDim2 relative, asi que se re-centra solo).
local rowTargets = {}
-- Ventanas vivas, para repintar la pestana activa al cambiar de estilo.
local Windows = {}

-- Ventana que se esta construyendo. Sirve para saber de quien es cada esquina
-- redondeada, para que SetRadius solo afecte a su propia ventana.
local buildingWindow = nil

-- Escala una medida del lateral por la densidad del estilo (alto de item, texto).
local function tabMetrics(value)
	return math.floor(value * styleState.Density + 0.5)
end

-- Alto final de una fila segun el estilo. Se redondea a pixeles enteros: en las
-- capturas las filas miden 20px justos, no 19.84.
local function rowHeight(base)
	local scaled = math.floor(base * styleState.RowScale + 0.5)
	-- Importante: los elementos contienen controles con alturas fijas.
	-- Si la fila baja de su altura base, el control se corta por arriba/abajo.
	-- La compactacion segura la hace Density mediante UIScale.
	return math.max(base, scaled)
end

-- Radio final y visibilidad del marco exterior de una ventana. El marco se
-- dibuja si el estilo trae borde (StrokeTransparency < 1) o si la ventana pide
-- radio con SetRadius. Sin nada de eso se queda recto y sin borde, que es lo
-- que hace Linea. Hace falta comparar en vez de usar "or" porque en Lua 0 es
-- VERDADERO: con un "or window.Radius" a secas, SetRadius(0) encendia el marco.
local function frameBorder(radius)
	if styleState.StrokeTransparency < 1 or (radius or 0) > 0 then
		return (radius or styleState.Radius) + 2, true
	end
	return 0, false
end

local function applyStyle()
	Config.Radius = styleState.Radius
	Config.RowScale = styleState.RowScale
	Config.Separator = styleState.Separator
	Config.Density = styleState.Density
	for index = 1, #styleTargets do
		local object = styleTargets[index]
		if object and object.Parent then
			object.BackgroundTransparency = styleState.CardTransparency
		end
	end
	for index = 1, #roundTargets do
		local entry = roundTargets[index]
		if entry and entry.Corner and entry.Corner.Parent then
			-- entry.Radius es el override de SetRadius de esa ventana; si no hay,
			-- manda el estilo.
			entry.Corner.CornerRadius = UDim.new(0, entry.Radius or styleState.Radius)
		end
	end
	for index = 1, #rowSeparators do
		local line = rowSeparators[index]
		if line and line.Parent then
			line.Visible = styleState.Separator and true or false
		end
	end
	-- Escalas de densidad: un unico UIScale por region, no uno por elemento.
	for index = 1, #densityTargets do
		local entry = densityTargets[index]
		if entry and entry.Parent then
			entry.Scale = styleState.Density
		end
	end
	for index = 1, #layoutTargets do
		local layout = layoutTargets[index]
		if layout and layout.Parent then
			layout.Padding = UDim.new(0, styleState.RowPadding)
		end
	end
	-- Bloques de cabecera de pagina (el rectangulo de 32px de las capturas).
	for index = 1, #headerBlocks do
		local block = headerBlocks[index]
		if block and block.Parent then
			block.Visible = styleState.Header and true or false
		end
	end
	-- Items del lateral: alto y texto al ritmo de la densidad.
	for index = 1, #tabItems do
		local entry = tabItems[index]
		if entry and entry.Frame and entry.Frame.Parent then
			entry.Frame.Size = UDim2.new(1, 0, 0, tabMetrics(entry.Height))
			entry.Frame.TextSize = tabMetrics(entry.TextSize)
		end
	end
	-- Filas de alto fijo: el estilo tambien las compacta en caliente.
	for index = 1, #rowTargets do
		local entry = rowTargets[index]
		if entry and entry.Frame and entry.Frame.Parent then
			entry.Frame.Size = UDim2.new(1, 0, 0, rowHeight(entry.BaseHeight))
		end
	end
	-- La pestana activa conserva el relleno que manda el estilo, y el marco
	-- exterior de cada ventana accompany al radio: en Linea se queda recto y sin
	-- borde, aunque la ventana se haya creado con otro estilo.
	for index = 1, #Windows do
		local window = Windows[index]
		if window then
			local marco, conBorde = frameBorder(window.Radius)
			if window.FrameCorners and window.FrameCorners.Parent then
				window.FrameCorners.CornerRadius = UDim.new(0, marco)
			end
			if window.FrameStroke and window.FrameStroke.Parent then
				window.FrameStroke.Color = Config.Stroke
				window.FrameStroke.Transparency = conBorde and 0.1 or 1
			end
			if window.activeTab then
				for position = 1, #window.tabs do
					local entry = window.tabs[position]
					if entry and entry.button then
						entry.button.BackgroundTransparency = (entry.tab == window.activeTab)
							and styleState.TabFill
							or 1
					end
				end
			end
		end
	end
	local strokes = tint.Stroke
	if strokes then
		for index = 1, #strokes do
			local object = strokes[index]
			-- En el rol "Stroke" conviven los UIStroke de los bordes y los Frames
			-- de 1px de las lineas separadoras. Solo los UIStroke llevan la
			-- transparencia del estilo: las lineas guardan la suya y su color lo
			-- repinta el tema. Asignar Transparency a un Frame es "Transparency is
			-- not a valid member of Frame" en Roblox.
			if object and object.Parent and object:IsA("UIStroke") then
				object.Transparency = styleState.StrokeTransparency
			end
		end
	end
end

local function round(object, radius)
	local corner = new("UICorner", { CornerRadius = UDim.new(0, radius or Config.Radius) }, object)
	-- Sin radio explicito = la esquina sigue al estilo, asi que se registra.
	if radius == nil then
		table.insert(roundTargets, { Corner = corner, Window = buildingWindow })
	end
	return corner
end

local function outline(object, color, thickness, transparency)
	if transparency == nil then
		transparency = styleState.StrokeTransparency
	end
	return tag("Stroke", new("UIStroke", {
		Color = color or Config.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, object))
end

-- El look es plano: los rellenos de acento son un color solido, sin degradado.
local function accentFill(object, rotation)
	object.BackgroundColor3 = Config.Accent
	return tag("Accent", object)
end

local function card(parent, size, position, class)
	local properties = {
		Size = size or UDim2.fromScale(1, 1),
		Position = position,
		BackgroundColor3 = Config.Card,
		BorderSizePixel = 0,
	}
	if class == "TextButton" then
		properties.Text = ""
	end
	local object = new(class or "Frame", properties, parent)
	round(object)
	-- Solo las tarjetas nacidas opacas siguen al estilo; las que ya traen su
	-- propia transparencia (pestanas, backdrop) se dejan como están.
	if properties.BackgroundTransparency == nil then
		table.insert(styleTargets, object)
	end
	return tag("Card", object)
end

local function label(parent, properties, role)
	properties = properties or {}
	properties.BackgroundTransparency = 1
	properties.Font = properties.Font or Config.Font
	properties.TextSize = properties.TextSize or Config.TextSize
	properties.TextColor3 = properties.TextColor3 or Config.Text
	if properties.TextXAlignment == nil then
		properties.TextXAlignment = Enum.TextXAlignment.Left
	end
	return tag(role or "Text", new("TextLabel", properties, parent))
end

local function button(parent, properties)
	properties.AutoButtonColor = false
	properties.BackgroundColor3 = properties.BackgroundColor3 or Config.Card
	properties.BorderSizePixel = 0
	properties.Font = properties.Font or Config.Font
	properties.TextSize = properties.TextSize or Config.TextSize
	properties.TextColor3 = properties.TextColor3 or Config.Text
	local object = new("TextButton", properties, parent)
	if properties.BackgroundTransparency == nil then
		table.insert(styleTargets, object)
	end
	return tag("Card", object)
end

local function hoverFill(object)
	object.MouseEnter:Connect(function()
		tween(object, { BackgroundColor3 = lighten(object.BackgroundColor3, styleState.Hover) }, Config.Anim)
	end)
	object.MouseLeave:Connect(function()
		tween(object, { BackgroundColor3 = Config.Card }, Config.Anim)
	end)
end

local function hoverGhost(object)
	object.MouseEnter:Connect(function()
		tween(object, { BackgroundTransparency = 0 }, Config.Anim)
	end)
	object.MouseLeave:Connect(function()
		tween(object, { BackgroundTransparency = 1 }, Config.Anim)
	end)
end

--[[ RAIZ DE LA GUI ]]--

local playerGui = resolvePlayerGui()
if not playerGui then
	playerGui = game:GetService("CoreGui")
end

local previous = playerGui:FindFirstChild("LunaDarkUI")
if previous then
	previous:Destroy()
end

local screen = new("ScreenGui", {
	Name = "LunaDarkUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 500,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local root = new("Frame", {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
}, screen)

local toastLayer = new("Frame", {
	Name = "Toasts",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ZIndex = 40,
}, root)

-- Escala de la interfaz segun la altura de la pantalla. Se declara aqui, antes
-- de showTooltip, porque esa funcion lo usa: si se declarara despues, Lua lo
-- tomaria como global (nil) y el tooltip reventaria al mostrarse.
local scaleValue = 1
-- Igual con viewport(): showTooltip la llama y estaba definida mas abajo, con
-- lo que Lua la buscaba como global nil y cualquier hover con tooltip fallaba.
local viewport = nil

-- Un solo tooltip para toda la libreria (se reutiliza en cada hover).
local tooltip = new("Frame", {
	Name = "Tooltip",
	Size = UDim2.fromOffset(10, 10),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 80,
	AutomaticSize = Enum.AutomaticSize.XY,
}, root)
local tooltipLabel = new("TextLabel", {
	Size = UDim2.fromOffset(10, 10),
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	Text = "",
	TextSize = 11,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	TextWrapped = true,
	ZIndex = 81,
}, tooltip)
new("UIPadding", {
	PaddingLeft = UDim.new(0, 7),
	PaddingRight = UDim.new(0, 7),
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 4),
}, tooltip)

local hideTooltip

local function showTooltip(message, host)
	if not message or message == "" then
		return
	end
	tooltipLabel.Text = tostring(message)
	tooltip.Visible = true
	local anchor = host.AbsolutePosition
	local size = host.AbsoluteSize
	local box = tooltip.AbsoluteSize
	local x = anchor.X - root.AbsolutePosition.X + (size.X / 2) - ((box and box.X or 60) / 2)
	local y = anchor.Y - root.AbsolutePosition.Y - ((box and box.Y or 20) + 8)
	local screenSize = viewport()
	x = clamp(x / scaleValue, 4, math.max(4, (screenSize.X / scaleValue) - 40))
	if y < 4 then
		y = (anchor.Y - root.AbsolutePosition.Y + size.Y + 8) / scaleValue
	end
	tooltip.Position = UDim2.fromOffset(roundValue(x), roundValue(y))
	tooltip.BackgroundColor3 = Config.Card
	tooltipLabel.TextColor3 = Config.Text
end

hideTooltip = function()
	tooltip.Visible = false
end

local uiScale = new("UIScale", { Scale = 1 }, root)

-- Asignacion (no "local function") porque ya se declaro antes, junto al
-- tooltip, para que showTooltip pueda usarla.
viewport = function()
	local camera = Workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1920, 1080)
end

local function applyScale()
	local size = viewport()
	-- 800x600 es la referencia visual de la libreria. Solo reducimos cuando
	-- la ventana ya no cabe en el viewport; en pantallas grandes no la inflamos.
	local fitX = (size.X - 20) / 800
	local fitY = (size.Y - 20) / 600
	scaleValue = clamp(min(fitX, fitY), 0.78, 1)
	uiScale.Scale = scaleValue
end

applyScale()

do
	local camera = Workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale)
	end
	Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(applyScale)
end

local function toRootPosition(guiObject)
	local origin = guiObject.AbsolutePosition - root.AbsolutePosition
	return Vector2.new(origin.X / scaleValue, origin.Y / scaleValue)
end

--[[ BOMBILLO COMPARTIDO (optimizacion) ]]
-- Antes cada ventana tenia su propio RenderStepped para el contador de FPS:
-- con 3 ventanas eran 3 callbacks por frame. Ahora hay UNA sola conexion para
-- toda la libreria, y solo se desconecta cuando no queda ninguna ventana viva.
local pumpTargets = {}
local pumpConnection = nil
local pumpFrames, pumpElapsed, currentFPS = 0, 0, 0

lib.GetFPS = function()
	return currentFPS
end

lib.GetPing = function()
	local ok, value = pcall(function()
		return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok and type(value) == "number" then
		return roundValue(value)
	end
	if LocalPlayer then
		ok, value = pcall(function()
			return LocalPlayer:GetNetworkPing()
		end)
		if ok and type(value) == "number" then
			return roundValue(value * 1000)
		end
	end
	return 0
end

lib.GetPlayerCount = function()
	local ok, roster = pcall(function()
		return Players:GetPlayers()
	end)
	if ok and type(roster) == "table" then
		return #roster
	end
	return 0
end

local function updatePump(deltaTime)
	if type(deltaTime) ~= "number" or deltaTime <= 0 then
		return
	end
	pumpFrames = pumpFrames + 1
	pumpElapsed = pumpElapsed + deltaTime
	if pumpElapsed < 1 then
		return
	end
	currentFPS = roundValue(pumpFrames / pumpElapsed)
	pumpFrames = 0
	pumpElapsed = 0
	for index = 1, #pumpTargets do
		local target = pumpTargets[index]
		if target then
			pcall(target.tick, currentFPS)
		end
	end
end

local function releasePump(window)
	for index = #pumpTargets, 1, -1 do
		if pumpTargets[index] == window then
			table.remove(pumpTargets, index)
		end
	end
	if #pumpTargets == 0 and pumpConnection then
		pumpConnection:Disconnect()
		pumpConnection = nil
	end
end

local function acquirePump(window)
	if pumpConnection then
		return
	end
	local signal = RunService.RenderStepped or RunService.Heartbeat
	if not signal then
		return
	end
	pumpConnection = signal:Connect(updatePump)
end

--[[ BASE DE ELEMENTOS ]]--

local Elements = {}
local ElementKinds = {
	"Button", "Toggle", "Slider", "Input", "Dropdown", "Label", "Progress", "Keybind",
	"Checkbox", "Combobox", "ButtonGroup", "TextArea", "ColorPicker", "Info",
}

local function makeRow(page, height, automatic)
	local order = page.order
	page.order = order + 1
	-- El estilo decide lo compacta que es una fila (las capturas usan filas de
	-- ~20px con una linea de 1px debajo en vez de tarjetas separadas).
	local frame = new("Frame", {
		Size = UDim2.new(1, 0, 0, rowHeight(height)),
		AutomaticSize = automatic or Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		LayoutOrder = order,
	}, page.container)
	-- El alto base y la linea van en tablas aparte, NO como campos del frame:
	-- una Instance no admite miembros nuevos. El registro lo usa applyStyle
	-- para compactar la fila despues sin recrear el elemento.
	if not automatic then
		table.insert(rowTargets, { Frame = frame, BaseHeight = height })
	end
	-- La linea se crea SIEMPRE y su visibilidad la decide el estilo, para que
	-- cambiar de estilo en caliente tambien afecte a las filas ya existentes.
	local line = tag("Stroke", new("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Config.Stroke,
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Visible = styleState.Separator and true or false,
	}, frame))
	table.insert(rowSeparators, line)
	return frame
end

local function rowHeader(frame, name, value)
	local left = label(frame, {
		Size = UDim2.new(1, -82, 1, 0),
		Text = tostring(name or ""),
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local right = label(frame, {
		Size = UDim2.new(0, 78, 1, 0),
		Position = UDim2.new(1, -98, 0, 0),
		Text = tostring(value or ""),
		TextColor3 = Config.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Config.MonoFont,
		TextSize = 12,
	}, "Accent")
	return left, right
end

local function normalizeOptions(nameOrOptions, extra)
	if type(nameOrOptions) == "string" then
		if type(extra) == "table" then
			local options = copyTable(extra)
			options.Name = nameOrOptions
			return options
		end
		if type(extra) == "function" then
			return { Name = nameOrOptions, Callback = extra }
		end
		return { Name = nameOrOptions }
	end
	if type(nameOrOptions) == "table" then
		if type(extra) == "function" then
			local options = copyTable(nameOrOptions)
			options.Callback = options.Callback or extra
			return options
		end
		return nameOrOptions
	end
	if type(extra) == "table" then
		return extra
	end
	if type(extra) == "function" then
		return { Callback = extra }
	end
	return {}
end

-- Si un executor rechaza algo de un elemento, no queremos cortar el script del
-- usuario: devolvemos una API minima para que AddX siga y el resto de la tab exista.
local installElementMethods

local function stubApi(options)
	local api = { _stub = true, _conns = {} }
	local value = options and (options.Default ~= nil and options.Default or options.Text)
	local text = options and options.Text or ""
	function api:GetValue() return value end
	function api:SetValue(newValue) value = newValue end
	function api:GetText() return text end
	function api:SetText(newText) text = tostring(newText or "") end
	function api:Select() end
	function api:Destroy() end
	function api:AddConnection() end
	return installElementMethods(api, nil)
end

-- Firma antigua (aceptada por compatibilidad):
--   AddX(nombre, callback)                     -- toggle, input, dropdown...
--   AddX(nombre, default, callback)            -- toggle, slider
--   AddSlider(nombre, min, max, default, callback)
--   AddDropdown(nombre, {"A","B"}, default, callback)
local function applyLegacySignature(kind, options, b, c, d, e)
	-- El dropdown es el unico que recibe una TABLA en la posicion del default:
	-- sin este caso, b = {"A","B"} se perdia y el menu salia con opciones falsas
	-- y sin Callback.
	if kind == "Dropdown" and type(b) == "table" then
		local result = options
		if #b > 0 then
			local values = {}
			for index = 1, #b do
				values[index] = b[index]
			end
			result.Options = values
		end
		if type(c) == "string" or type(c) == "number" then
			result.Default = c
		end
		local callback
		if type(c) == "function" then
			callback = c
		elseif type(d) == "function" then
			callback = d
		elseif type(e) == "function" then
			callback = e
		end
		if callback and not result.Callback then
			result.Callback = callback
		end
		return result
	end
	if type(b) ~= "number" and type(b) ~= "boolean" then
		return options
	end
	local result = copyTable(options)
	if kind == "Slider" and type(c) == "number" then
		result.Min = b
		result.Max = c
		if type(d) == "number" then
			result.Default = d
		end
		if type(e) == "function" then
			result.Callback = e
		end
		return result
	end
	result.Default = b
	if type(c) == "function" then
		result.Callback = c
	elseif type(d) == "function" then
		result.Callback = d
	end
	return result
end

installElementMethods = function(target, page)
	for index = 1, #ElementKinds do
		local kind = ElementKinds[index]
		target["Add" .. kind] = function(_, a, b, c, d, e)
			local options = applyLegacySignature(kind, normalizeOptions(a, b), b, c, d, e)
			local ok, result = pcall(Elements[kind], page, options)
			if ok then
				return result
			end
			warnElement(kind, result)
			return stubApi(options)
		end
	end
	-- api:Tooltip("texto") en CUALQUIER elemento. Hay un unico marco de tooltip
	-- para toda la libreria: 200 elementos no crean 200 marcos.
	if target.Tooltip == nil and target.Frame ~= nil then
		function target:Tooltip(text)
			local message = tostring(text or "")
			if message == "" or not Config.Tooltips then
				return
			end
			local host = self.Frame
			host.MouseEnter:Connect(function()
				defer(0.35, function()
					if host.Parent and host.Visible then
						showTooltip(message, host)
					end
				end)
			end)
			host.MouseLeave:Connect(hideTooltip)
		end
	end
	return target
end

local function elementApi(frame, page)
	local api = { Frame = frame, _conns = {} }
	local window = page and page.window
	-- Las esquinas que se creen a partir de aqui son de esta ventana.
	buildingWindow = window

	function api:AddConnection(item)
		table.insert(self._conns, item)
	end

	local unregister = nil
	if window then
		unregister = window:AddConnection(function()
			api:Destroy()
		end)
	end

	function api:Destroy()
		if unregister then
			unregister()
			unregister = nil
		end
		if self.dragCancel then
			self.dragCancel()
			self.dragCancel = nil
		end
		for index = 1, #self._conns do
			local item = self._conns[index]
			if type(item) == "function" then
				item()
			else
				item:Disconnect()
			end
		end
		clearTable(self._conns)
		if self.Frame then
			self.Frame:Destroy()
		end
	end

	return installElementMethods(api, page)
end

--[[ ELEMENTOS ]]--

function Elements.Button(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 34)
	local control = button(frame, {
		-- 4px a cada lado: con Size = 1,-8 y Position en 0 la tarjeta se quedaba
		-- pegada a la izquierda (8px de margen solo a la derecha).
		Size = UDim2.new(1, -8, 1, 0),
		Position = UDim2.fromOffset(4, 0),
		AnchorPoint = Vector2.new(0, 0),
		ClipsDescendants = false,
		Text = tostring(options.Name or "Boton"),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
	}, control)
	outline(control)
	hoverFill(control)

	local api = elementApi(frame, page)
	api.Control = control
	-- -1 y no 0: con 0, os.clock() tambien puede valer menos de 0.08 y el
	-- primer clic de la UI se perderia nada mas cargar la libreria.
	local lastClick = -1
	local function press()
		local now = os.clock()
		if (now - lastClick) < 0.08 then
			return
		end
		lastClick = now
		tween(control, { BackgroundColor3 = lighten(Config.Card, 0.1) }, 0.06)
		defer(0.09, function()
			if control.Parent then
				tween(control, { BackgroundColor3 = Config.Card }, Config.Anim)
			end
		end)
		if options.Callback then
			options.Callback(api)
		end
	end
	function api:GetText()
		return control.Text
	end
	function api:SetText(text)
		if control.Parent then
			control.Text = tostring(text or "")
		end
	end
	-- Activated es la unica fuente de click. Antes se mezclaba con
	-- InputBegan/InputEnded y un solo click podia ejecutar el callback varias veces.
	control.Activated:Connect(press)
	return api
end

function Elements.Toggle(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 32)
	local nameLabel = label(frame, {
		Size = UDim2.new(1, -64, 1, 0),
		Text = tostring(options.Name or "Toggle"),
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local track = card(frame, UDim2.fromOffset(42, 20), UDim2.new(1, -50, 0.5, -10), "TextButton")
	outline(track, Config.Stroke, 1, 0.35)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(14, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.24, 0, 0.5, 0),
		BackgroundColor3 = Config.Muted,
		BorderSizePixel = 0,
	}, track)
	round(knob, 7)

	local hit = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 6,
	}, frame)

	local state = options.Default and true or false
	-- -1 y no 0: con 0, os.clock() tambien puede valer menos de 0.08 y el
	-- primer clic de la UI se perderia nada mas cargar la libreria.
	local lastClick = -1

	local function render(animate)
		local knobOffset = state and 0.76 or 0.24
		local knobColor = state and Config.Text or Config.Muted
		if animate then
			tween(track, { BackgroundColor3 = state and Config.Accent or Config.Card }, Config.Anim)
			tween(knob, { Position = UDim2.new(knobOffset, 0, 0.5, 0), BackgroundColor3 = knobColor }, Config.Anim)
		else
			track.BackgroundColor3 = state and Config.Accent or Config.Card
			knob.Position = UDim2.new(knobOffset, 0, 0.5, 0)
			knob.BackgroundColor3 = knobColor
		end
	end

	local function setState(value, animate)
		state = value and true or false
		render(animate ~= false)
	end

	local function toggle(fromUser)
		-- El rebote de 0.08s solo filtra el input real (un clic dispara
		-- Activated + InputBegan a la vez). Una llamada desde codigo, como
		-- api:Toggle(), siempre cuenta.
		if fromUser ~= false then
			local now = os.clock()
			if (now - lastClick) < 0.08 then
				return
			end
			lastClick = now
		end
		setState(not state, true)
		if options.Callback then
			options.Callback(state)
		end
	end

	local api = elementApi(frame, page)
	api.Control = track
	api.TextLabel = nameLabel
	function api:GetText()
		return nameLabel.Text
	end
	function api:SetText(text)
		if nameLabel.Parent then
			nameLabel.Text = tostring(text or "")
		end
	end
	-- Un solo receptor de click. El antiguo hitbox de fila + InputBegan
	-- provocaba que un click se procesara dos veces y el toggle pareciera no cambiar.
	hit:Destroy()
	track.Activated:Connect(function()
		toggle()
	end)
	render(false)

	function api:SetValue(value)
		setState(value, true)
	end

	function api:GetValue()
		return state
	end

	function api:Toggle()
		toggle(false)
	end

	return api
end

function Elements.Slider(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local minimum = options.Min or 0
	local maximum = options.Max or 100
	-- Sin Step explicito: rangos cortos usan decimales para que no salte de 1 en 1
	local step = options.Step or ((maximum - minimum) <= 20 and 0.1 or 1)
	local suffix = options.Suffix or ""
	local value = options.Default or minimum

	local frame = makeRow(page, 42)
	local nameLabel, valueLabel = rowHeader(frame, options.Name or "Slider", "")

	local track = new("Frame", {
		Size = UDim2.new(1, -20, 0, 3.8),
		-- y=34 dentro de una fila de 42: antes iba en 39 y el borde inferior se
		-- salia de la fila (aba = -0.8).
		Position = UDim2.fromOffset(10, 39),
		BackgroundColor3 = Config.Card,
		BorderSizePixel = 0,
	}, frame)
	round(track, 2)
	outline(track, Config.Stroke, 1, styleState.TrackTransparency)

	local fill = new("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, track)
	accentFill(fill)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(12, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		BackgroundColor3 = Config.Text,
		BorderSizePixel = 0,
		ZIndex = 3,
	}, track)
	round(knob, 6)
	new("UIStroke", {
		Color = Config.Stroke,
		Thickness = 1,
		Transparency = 0.4,
		Thickness = 1,
	}, knob)

	local hit = new("Frame", {
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(0, 25),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 4,
	}, frame)

	local function render(animate)
		local ratio = (value - minimum) / ((maximum - minimum) or 1)
		if ratio < 0 then
			ratio = 0
		elseif ratio > 1 then
			ratio = 1
		end
		valueLabel.Text = formatNumber(value) .. suffix
		if animate then
			tween(fill, { Size = UDim2.fromScale(ratio, 1) }, 0.12)
			tween(knob, { Position = UDim2.fromScale(ratio, 0.5) }, 0.12)
		else
			fill.Size = UDim2.fromScale(ratio, 1)
			knob.Position = UDim2.fromScale(ratio, 0.5)
		end
	end

	local function setValue(newValue, animate)
		newValue = clamp(newValue, minimum, maximum)
		if step and step > 0 then
			newValue = minimum + math.floor((newValue - minimum) / step + 0.5) * step
		end
		local changed = newValue ~= value
		value = newValue
		render(animate ~= false)
		if changed and options.Callback then
			options.Callback(value)
		end
	end

	local function valueFromPointer(position)
		local origin = track.AbsolutePosition.X
		local size = track.AbsoluteSize.X
		if size == 0 then
			return value
		end
		local ratio = clamp((position.X - origin) / size, 0, 1)
		return minimum + ratio * (maximum - minimum)
	end

	local api = elementApi(frame, page)

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			setValue(valueFromPointer(pointerPosition(input)), false)
			if api.dragCancel then
				api.dragCancel()
			end
			api.dragCancel = beginDrag(function(move)
				setValue(valueFromPointer(pointerPosition(move)), false)
			end)
		end
	end)

	render(false)

	function api:SetValue(newValue)
		setValue(newValue, true)
	end

	function api:GetValue()
		return value
	end

	api.Label = nameLabel
	-- Pistas y piezas visibles, por si hay que tocarlas o medirlas.
	api.Track = track
	api.Fill = fill
	api.Knob = knob
	return api
end

function Elements.Input(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 50)
	label(frame, {
		Size = UDim2.new(1, 0, 0, 15),
		Text = string.upper(tostring(options.Name or "Input")),
		TextSize = 11,
		Font = Config.MonoFont,
		TextColor3 = Config.Muted,
	}, "Muted")

	-- 10px a cada lado, como las pistas de Slider y Progress. Con 0.98 de escala
	-- en Position 0 el campo se pegaba a la izquierda.
	local field = card(frame, UDim2.new(1, -20, 0, 17), UDim2.fromOffset(10, 18.8))
	local border = outline(field, Config.Stroke, 1, 0.4)

	local box = new("TextBox", {
		-- 5px dentro del campo a cada lado, y centrado verticalmente (17/2).
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.fromOffset(5, 8.5),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Text = tostring(options.Default or ""),
		PlaceholderText = options.Placeholder or "",
		PlaceholderColor3 = Config.Muted,
		TextColor3 = Config.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Config.MonoFont,
		TextSize = 12,
		ClearTextOnFocus = false,
		MultiLine = false,
	}, field)

	local api = elementApi(frame, page)
	-- El TextBox, como en Button/Toggle/Checkbox, para poder leerlo o ajustarlo.
	api.Control = box
	-- Senal propia para poder enganchar input.Changed:Connect(...) sin tocar
	-- el TextBox de Roblox directamente.
	api.Changed = new("BindableEvent", { Name = "LunaDarkChanged" })

	local function focusStyle(focused)
		if border and border.Parent then
			tween(border, {
				Color = focused and Config.Accent or Config.Stroke,
				Transparency = focused and 0.05 or 0.4,
			}, 0.12)
		end
	end

	box.Focused:Connect(function()
		focusStyle(true)
	end)
	box.FocusLost:Connect(function()
		focusStyle(false)
		if options.Callback then
			options.Callback(box.Text)
		end
		api.Changed:Fire(box.Text)
	end)

	function api:SetValue(text)
		box.Text = tostring(text or "")
		api.Changed:Fire(box.Text)
	end

	function api:GetValue()
		return box.Text
	end

	function api:Focus()
		box:CaptureFocus()
	end

	return api
end

--[[ FONDO COMUN DE LOS DESPLEGABLES ]]--
-- Boton invisible a pantalla completa, DETRAS de los menus (ZIndex menor).
-- Es el que cierra el dropdown al pulsar fuera, sin comparar coordenadas del
-- raton con AbsolutePosition (esa comparacion fallaba y cerraba el menu antes
-- de que la opcion recibiera su Activated, dejando el valor sin cambiar).
local menuBackdrop = button(root, {
	Name = "LunaDarkMenuBackdrop",
	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromOffset(0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Text = "",
	Active = true,
	Visible = false,
	ZIndex = 55,
})
local openMenuCloser = nil
menuBackdrop.Activated:Connect(function()
	if openMenuCloser then
		openMenuCloser()
	end
end)

function Elements.Dropdown(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	-- Si no vino Options, la propia tabla puede ser la lista (firma antigua)
	local list = options.Options
	if type(list) ~= "table" then
		local values = {}
		for index = 1, #options do
			values[index] = options[index]
		end
		list = values
	end
	if #list == 0 then
		list = { "Opcion A", "Opcion B", "Opcion C" }
	end
	local selected = options.Default or list[1]

	local frame = makeRow(page, 32)
	local control = button(frame, {
		-- Centrado: 8px a cada lado. Con Size = 1,-16 y Position en 0 la tarjeta
		-- se pegaba a la izquierda y solo quedaba margen a la derecha.
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		Text = "",
	})
	outline(control)
	hoverFill(control)

	label(control, {
		Size = UDim2.new(1, -76, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		Text = tostring(options.Name or "Dropdown"),
		TextColor3 = Config.Muted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, "Muted")

	local valueLabel = label(control, {
		Size = UDim2.new(0, 60, 1, 0),
		Position = UDim2.new(1, -85, 0, 0),
		Text = tostring(selected),
		TextColor3 = Config.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Config.MonoFont,
		TextSize = 12,
	}, "Accent")

	local arrow = tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(6, 6),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Rotation = 45,
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, control))
	round(arrow, 1)

	local visible = math.min(#list, 6)
	local menuHeight = visible * 26 + 8
	local menu = card(root, UDim2.fromOffset(200, menuHeight), UDim2.fromOffset(0, 0), "Frame")
	menu.Visible = false
	menu.ZIndex = 60
	outline(menu, Config.Accent, 1, 0.15)

	local scroller = new("ScrollingFrame", {
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.fromOffset(2, 2),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Config.Accent,
		ScrollBarImageTransparency = 0.2,
		ZIndex = 60,
	}, menu)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }, scroller)

	local api = elementApi(frame, page)
	api.Control = control
	local optionButtons = {}
	local open = false

	local function close()
		if not open then
			return
		end
		open = false
		menu.Visible = false
		menuBackdrop.Visible = false
		if openMenuCloser == close then
			openMenuCloser = nil
		end
		tween(arrow, { Rotation = 45 }, Config.Anim)
	end

	local function place()
		local size = viewport()
		local width = math.max(120, control.AbsoluteSize.X / scaleValue)
		local anchor = toRootPosition(control)
		local y = anchor.Y + (control.AbsoluteSize.Y / scaleValue) + 4
		if (y + menuHeight) > (size.Y / scaleValue) - 8 then
			y = math.max(8, anchor.Y - menuHeight - 4)
		end
		local x = clamp(anchor.X, 8, math.max(8, (size.X / scaleValue) - width - 8))
		menu.Size = UDim2.fromOffset(width, menuHeight)
		menu.Position = UDim2.fromOffset(x, y)
	end

	local function openMenu()
		if open or #list == 0 then
			return
		end
		open = true
		menu.Visible = true
		menuBackdrop.Visible = true
		openMenuCloser = close
		tween(arrow, { Rotation = 225 }, Config.Anim)
		place()
	end

	local function selectOption(value)
		selected = value
		valueLabel.Text = tostring(selected)
		for _, entry in ipairs(optionButtons) do
			-- Contra el valor de cada boton, no contra list[position]: si la lista
			-- se filtra, optionButtons y list dejan de compartir posiciones.
			entry.TextColor3 = tostring(optionValue(entry)) == tostring(selected)
				and Config.Accent
				or Config.Text
		end
		close()
		if options.Callback then
			options.Callback(selected)
		end
	end

	local function refreshOptions()
		for index = #optionButtons, 1, -1 do
			local entry = optionButtons[index]
			entry:Destroy()
			optionButtons[index] = nil
		end

		for index = 1, #list do
			local value = list[index]
			local option = button(scroller, {
				Size = UDim2.new(1, 0, 0, 26),
				LayoutOrder = index,
				Text = tostring(value),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = tostring(value) == tostring(selected) and Config.Accent or Config.Text,
				TextSize = 12,
				BackgroundTransparency = 1,
				Active = true,
				ZIndex = 60,
			})
			rememberOption(option, value)
			new("UIPadding", { PaddingLeft = UDim.new(0, 10) }, option)
			hoverGhost(option)
			-- Activated evita seleccionar la misma opcion dos veces en un click.
			option.Activated:Connect(function()
				if open then
					selectOption(value)
				end
			end)
			table.insert(optionButtons, option)
		end
	end

	control.Activated:Connect(function()
		if open then
			close()
		else
			openMenu()
		end
	end)

	refreshOptions()

	local overlay = { Close = close }
	if page.window then
		page.window:AddRelayout(place)
		page.window:AddOverlay(overlay)
	end

	api:AddConnection(function()
		close()
		menu:Destroy()
		if page.window then
			page.window:RemoveRelayout(place)
			page.window:RemoveOverlay(overlay)
		end
	end)

	function api:SetValue(value)
		selected = value
		valueLabel.Text = tostring(value)
		for index, entry in ipairs(optionButtons) do
			entry.TextColor3 = tostring(list[index]) == tostring(value) and Config.Accent or Config.Text
		end
	end

	function api:GetValue()
		return selected
	end

	function api:SetOptions(newList)
		list = newList or {}
		visible = math.min(#list, 6)
		menuHeight = visible * 26 + 8
		menu.Size = UDim2.fromOffset(menu.Size.X.Offset, menuHeight)
		refreshOptions()
		if #list == 0 then
			close()
		elseif open then
			place()
		end
	end

	function api:GetOptions()
		return list
	end

	return api
end

function Elements.Label(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 18, Enum.AutomaticSize.Y)
	local text = label(frame, {
		Size = UDim2.new(1, 0, 0, 18),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = tostring(options.Text or options.Name or "Etiqueta"),
		TextWrapped = true,
		TextColor3 = options.Color or Config.Muted,
		TextSize = options.Size or 12,
		Font = Config.MonoFont,
	}, options.Color and "Text" or "Muted")
	local api = elementApi(frame, page)
	api.Label = text
	function api:SetValue(newText)
		text.Text = tostring(newText)
	end
	function api:GetValue()
		return text.Text
	end
	return api
end

function Elements.Progress(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	-- El rango es 0..100 por defecto, pero admite Max (por ejemplo, bytes o
	-- elementos) en lugar de fingir un SetMax que no existia.
	local maximum = tonumber(options.Max) or 100
	if maximum <= 0 then
		maximum = 100
	end
	local function asPercent(number)
		return formatNumber(clamp(number, 0, maximum) / maximum * 100) .. "%"
	end
	local value = clamp(options.Default or 0, 0, maximum)

	local frame = makeRow(page, 40)
	local nameLabel, valueLabel = rowHeader(frame, options.Name or "Progreso", asPercent(value))

	local track = new("Frame", {
		-- Como la pista del Slider: 10px a cada lado. Con 0.95 de escala en
		-- Position 0 se quedaba pegada a la izquierda.
		Size = UDim2.new(1, -20, 0, 5.5),
		Position = UDim2.fromOffset(10, 30),
		BackgroundColor3 = Config.Card,
		BorderSizePixel = 0,
	}, frame)
	round(track, 3)

	local fill = new("Frame", {
		Size = UDim2.fromScale(value / maximum, 1),
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, track)
	accentFill(fill)

	local api = elementApi(frame, page)

	function api:SetValue(newValue, seconds)
		value = clamp(newValue, 0, maximum)
		valueLabel.Text = asPercent(value)
		tween(fill, { Size = UDim2.fromScale(value / maximum, 1) }, seconds or 0.25)
	end

	function api:GetValue()
		return value
	end

	function api:GetMax()
		return maximum
	end

	api.Label = nameLabel
	api.Track = track
	api.Fill = fill
	return api
end

function Elements.Keybind(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 32)
	local control = button(frame, {
		-- Centrado: 8px a cada lado (con -16 en Position 0 solo quedaba margen
		-- a la derecha).
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		Text = "",
	})
	outline(control)
	hoverFill(control)

	label(control, {
		Size = UDim2.new(1, -105, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		Text = tostring(options.Name or "Bindeo"),
		TextColor3 = Config.Muted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, "Muted")

	local valueLabel = label(control, {
		Size = UDim2.new(0, 88, 1, 0),
		Position = UDim2.new(1, -98, 0, 0),
		Text = "",
		TextColor3 = Config.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Config.MonoFont,
		TextSize = 12,
	}, "Accent")

	local key = options.Key or Enum.KeyCode.Unknown
	local armed = false
	local waiting = nil

	local function render()
		if armed then
			valueLabel.Text = "[ press to impress ]"
		elseif key == Enum.KeyCode.Unknown then
			valueLabel.Text = "Click to select"
		else
			valueLabel.Text = key.Name
		end
	end

	local api = elementApi(frame, page)
	api.Control = control

	control.Activated:Connect(function()
		if armed then
			return
		end
		armed = true
		render()
		local connection
		connection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed or UserInputService:GetFocusedTextBox() then
				return
			end
			connection:Disconnect()
			armed = false
			key = input.KeyCode
			render()
			if options.Callback then
				options.Callback(key)
			end
		end)
		api:AddConnection(function()
			if connection then
				connection:Disconnect()
			end
		end)
	end)

	function api:SetValue(newKey)
		key = newKey
		render()
	end

	function api:GetValue()
		return key
	end

	render()
	return api
end

--[[ ELEMENTOS NUEVOS ]]--

-- Checkbox: caja cuadrada de 1px con una marca, para cuando el toggle
-- (que es una pila) no encaja con la estetica de la captura.
function Elements.Checkbox(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 26)
	local nameLabel = label(frame, {
		Size = UDim2.new(1, -46, 1, 0),
		Text = tostring(options.Name or "Checkbox"),
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local box = card(frame, UDim2.fromOffset(16, 16), UDim2.new(1, -24, 0.5, -8), "TextButton")
	outline(box, Config.Stroke, 1, 0.2)
	local mark = tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(8, 2),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = -45,
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, box))
	local markBack = tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(8, 2),
		Position = UDim2.new(0.5, 0, 0.5, -5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = 45,
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, box))

	local state = options.Default and true or false
	-- -1 y no 0: con 0, os.clock() tambien puede valer menos de 0.08 y el
	-- primer clic de la UI se perderia nada mas cargar la libreria.
	local lastClick = -1

	local function render(animate)
		mark.Visible = state
		markBack.Visible = state
		if animate then
			tween(box, { BackgroundColor3 = state and Config.Accent or Config.Card }, Config.Anim)
		else
			box.BackgroundColor3 = state and Config.Accent or Config.Card
		end
	end

	local function toggle(fromUser)
		-- El rebote de 0.08s solo filtra el input real (un clic dispara
		-- Activated + InputBegan a la vez). Una llamada desde codigo, como
		-- api:Toggle(), siempre cuenta.
		if fromUser ~= false then
			local now = os.clock()
			if (now - lastClick) < 0.08 then
				return
			end
			lastClick = now
		end
		state = not state
		render(true)
		if options.Callback then
			options.Callback(state)
		end
	end

	local api = elementApi(frame, page)
	api.Control = box
	api.TextLabel = nameLabel
	-- Un solo receptor: Activated. El handler InputBegan duplicaba el click.
	box.Activated:Connect(function() toggle(true) end)
	render(false)

	function api:SetValue(value)
		state = value and true or false
		render(true)
	end

	function api:GetValue()
		return state
	end

	function api:Toggle()
		toggle(false)
	end

	function api:GetText()
		return nameLabel.Text
	end

	function api:SetText(text)
		if nameLabel.Parent then
			nameLabel.Text = tostring(text or "")
		end
	end

	return api
end

-- Combobox: dropdown con buscador. Mismo overlay que el dropdown normal, pero
-- encima del menu hay un TextBox que filtra la lista mientras se escribe.
function Elements.Combobox(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local list = options.Options
	if type(list) ~= "table" then
		local values = {}
		for index = 1, #options do
			values[index] = options[index]
		end
		list = values
	end
	if #list == 0 then
		list = { "Opcion A", "Opcion B", "Opcion C" }
	end
	local selected = options.Default or list[1]

	local frame = makeRow(page, 32)
	local control = button(frame, {
		-- Centrado: 8px a cada lado. Con Size = 1,-16 sin Position la tarjeta se
		-- pegaba a la izquierda y solo quedaba margen a la derecha.
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		Text = "",
	})
	outline(control)
	hoverFill(control)

	label(control, {
		Size = UDim2.new(1, -76, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		Text = tostring(options.Name or "Combobox"),
		TextColor3 = Config.Muted,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, "Muted")

	local valueLabel = label(control, {
		Size = UDim2.new(0, 60, 1, 0),
		Position = UDim2.new(1, -76, 0, 0),
		Text = tostring(selected),
		TextColor3 = Config.Accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Config.MonoFont,
		TextSize = 12,
	}, "Accent")

	local arrow = tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(6, 6),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Rotation = 45,
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, control))
	round(arrow, 1)

	local searchHeight = 24
	local visible = math.min(#list, 6)
	local menuHeight = visible * 26 + 8 + searchHeight
	local menu = card(root, UDim2.fromOffset(220, menuHeight), UDim2.fromOffset(0, 0), "Frame")
	menu.Visible = false
	menu.ZIndex = 60
	outline(menu, Config.Accent, 1, 0.15)

	local searchField = card(menu, UDim2.new(1, -8, 0, searchHeight - 6), UDim2.fromOffset(4, 4))
	outline(searchField, Config.Stroke, 1, 0.35)
	local searchBox = new("TextBox", {
		Size = UDim2.new(1, -8, 1, 0),
		Position = UDim2.fromOffset(4, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Buscar...",
		PlaceholderColor3 = Config.Muted,
		TextColor3 = Config.Text,
		TextSize = 12,
		Font = Config.MonoFont,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ZIndex = 61,
	}, searchField)

	local scroller = new("ScrollingFrame", {
		Size = UDim2.new(1, -4, 1, -searchHeight - 8),
		Position = UDim2.fromOffset(2, searchHeight + 4),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Config.Accent,
		ScrollBarImageTransparency = 0.2,
		ZIndex = 60,
	}, menu)
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }, scroller)

	local api = elementApi(frame, page)
	local optionButtons = {}
	-- Utiles para inspeccionar el desplegable desde fuera (y para las pruebas).
	-- Control es el boton que ABRE el menu, igual que en Dropdown y Keybind;
	-- SearchBox es el filtro, que vive dentro del menu, no dentro del control.
	api.Control = control
	api.SearchBox = searchBox
	api.OptionButtons = optionButtons
	local open = false
	local highlighted = 0

	local function matches(value)
		local query = string.lower(searchBox.Text or "")
		if query == "" then
			return true
		end
		return string.find(string.lower(tostring(value)), query, 1, true) ~= nil
	end

	local function close()
		if not open then
			return
		end
		open = false
		menu.Visible = false
		menuBackdrop.Visible = false
		if openMenuCloser == close then
			openMenuCloser = nil
		end
		tween(arrow, { Rotation = 45 }, Config.Anim)
	end

	local function place()
		local size = viewport()
		local menuWidth = math.max(180, control.AbsoluteSize.X / scaleValue)
		local anchor = toRootPosition(control)
		local y = anchor.Y + (control.AbsoluteSize.Y / scaleValue) + 4
		if (y + menuHeight) > (size.Y / scaleValue) - 8 then
			y = math.max(8, anchor.Y - menuHeight - 4)
		end
		local x = clamp(anchor.X, 8, math.max(8, (size.X / scaleValue) - menuWidth - 8))
		menu.Size = UDim2.fromOffset(menuWidth, menuHeight)
		menu.Position = UDim2.fromOffset(x, y)
	end

	local function selectOption(value)
		selected = value
		valueLabel.Text = tostring(selected)
		for _, entry in ipairs(optionButtons) do
			-- Contra el valor de cada boton, no contra list[position]: al filtrar,
			-- optionButtons y list dejan de compartir posiciones.
			entry.TextColor3 = tostring(optionValue(entry)) == tostring(selected)
				and Config.Accent
				or Config.Text
		end
		close()
		if options.Callback then
			options.Callback(selected)
		end
	end

	local function refreshOptions()
		for index = #optionButtons, 1, -1 do
			optionButtons[index]:Destroy()
			optionButtons[index] = nil
		end
		highlighted = 0
		for index = 1, #list do
			local value = list[index]
			if matches(value) then
				highlighted = highlighted + 1
				local option = button(scroller, {
					Size = UDim2.new(1, 0, 0, 26),
					LayoutOrder = highlighted,
					Text = tostring(value),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = tostring(value) == tostring(selected) and Config.Accent or Config.Text,
					TextSize = 12,
					BackgroundTransparency = 1,
					Active = true,
					ZIndex = 60,
				})
				rememberOption(option, value)
				new("UIPadding", { PaddingLeft = UDim.new(0, 10) }, option)
				hoverGhost(option)
				option.Activated:Connect(function()
					if open then
						selectOption(value)
					end
				end)
				table.insert(optionButtons, option)
			end
		end
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		refreshOptions()
	end)

	-- Flechas para moverse por la lista y Enter para elegir. Backspace no se
	-- toca: lo necesita el TextBox para borrar del filtro.
	searchBox.InputBegan:Connect(function(input)
		local key = input.KeyCode
		if key == Enum.KeyCode.Up then
			highlighted = math.max(1, highlighted - 1)
		elseif key == Enum.KeyCode.Down then
			highlighted = math.min(#optionButtons, highlighted + 1)
		elseif key == Enum.KeyCode.Return then
			local target = optionButtons[highlighted]
			if target then
				-- target.Value, no target.Text: un valor no textual debe seguir
				-- siendo el que dio el usuario.
				selectOption(optionValue(target))
			end
		end
	end)

	control.Activated:Connect(function()
		if open then
			close()
		else
			open = true
			menu.Visible = true
			menuBackdrop.Visible = true
			openMenuCloser = close
			searchBox.Text = ""
			refreshOptions()
			tween(arrow, { Rotation = 225 }, Config.Anim)
			place()
		end
	end)

	local overlay = { Close = close }
	if page.window then
		page.window:AddRelayout(place)
		page.window:AddOverlay(overlay)
	end

	api:AddConnection(function()
		close()
		menu:Destroy()
		if page.window then
			page.window:RemoveRelayout(place)
			page.window:RemoveOverlay(overlay)
		end
	end)

	function api:SetValue(value)
		selected = value
		valueLabel.Text = tostring(value)
	end

	function api:GetValue()
		return selected
	end

	function api:SetOptions(newList)
		if type(newList) ~= "table" then
			return
		end
		list = newList
		refreshOptions()
	end

	function api:GetOptions()
		return list
	end

	function api:Search(text)
		searchBox.Text = tostring(text or "")
		refreshOptions()
		return #optionButtons
	end

	function api:GetText()
		return valueLabel.Text
	end

	function api:SetText(text)
		valueLabel.Text = tostring(text or "")
	end

	return api
end

-- ButtonGroup: fila de botones de los que solo uno puede estar activo.
function Elements.ButtonGroup(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local list = options.Options
	if type(list) ~= "table" then
		local values = {}
		for index = 1, #options do
			values[index] = options[index]
		end
		list = values
	end
	if #list == 0 then
		list = { "A", "B", "C" }
	end
	local selected = options.Default or list[1]

	local frame = makeRow(page, 34)
	local count = #list
	local gap = 4
	-- Los botones van en una tira con UIListLayout: el ancho de cada uno se
	-- reparte en escala, descontando la mitad de los huecos que el layout
	-- anade, asi la fila ni se sale ni depende de un ancho fijo en pixeles
	-- (antes usaba 496/620 y se desbordaba al cambiar el tamano de la ventana).
	local strip = new("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, frame)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, gap),
	}, strip)
	local slotScale = 1 / count
	local gapOffset = -(gap * (count - 1)) / count

	local buttons = {}
	for index = 1, count do
		local value = list[index]
		local item = button(strip, {
			Size = UDim2.new(slotScale, gapOffset, 1, 0),
			LayoutOrder = index,
			Text = tostring(value),
			TextSize = 12,
			TextColor3 = tostring(value) == tostring(selected) and Config.Accent or Config.Muted,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		outline(item)
		hoverFill(item)
		table.insert(buttons, { Frame = item, Value = value })
	end

	local function render(animate)
		for index = 1, #buttons do
			local entry = buttons[index]
			local active = tostring(entry.Value) == tostring(selected)
			if animate then
				tween(entry.Frame, {
					BackgroundColor3 = active and Config.Accent or Config.Card,
					TextColor3 = active and Config.Text or Config.Muted,
				}, Config.Anim)
			else
				entry.Frame.BackgroundColor3 = active and Config.Accent or Config.Card
				entry.Frame.TextColor3 = active and Config.Text or Config.Muted
			end
		end
	end

	local function pick(value)
		selected = value
		render(true)
		if options.Callback then
			options.Callback(selected)
		end
	end

	local api = elementApi(frame, page)
	api.Buttons = buttons
	for index = 1, #buttons do
		local entry = buttons[index]
		entry.Frame.Activated:Connect(function()
			pick(entry.Value)
		end)
	end
	render(false)

	function api:SetValue(value)
		selected = value
		render(true)
	end

	function api:GetValue()
		return selected
	end

	function api:GetOptions()
		return list
	end

	function api:SetText(text)
		for index = 1, #buttons do
			buttons[index].Frame.Text = tostring(text or "")
		end
	end

	function api:GetText()
		return tostring(selected)
	end

	return api
end

-- TextArea: campo multilinea. Util para notas, comandos o logs.
function Elements.TextArea(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local height = options.Height or 64
	local frame = makeRow(page, height + 18)

	if options.Name then
		label(frame, {
			Size = UDim2.new(1, 0, 0, 15),
			Text = string.upper(tostring(options.Name)),
			TextSize = 11,
			Font = Config.MonoFont,
			TextColor3 = Config.Muted,
		}, "Muted")
	end

	local field = card(frame, UDim2.new(1, -16, 0, height), UDim2.fromOffset(8, 16))
	local border = outline(field, Config.Stroke, 1, 0.4)

	local box = new("TextBox", {
		-- 6px de aire a cada lado dentro del campo (antes el UIPadding no hacia
		-- nada, porque el TextBox va posicionado a mano y no lo colocaba el layout).
		Size = UDim2.new(1, -12, 1, -10),
		Position = UDim2.fromOffset(6, 5),
		BackgroundTransparency = 1,
		Text = tostring(options.Default or options.Text or ""),
		PlaceholderText = options.Placeholder or "",
		PlaceholderColor3 = Config.Muted,
		TextColor3 = Config.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = Config.MonoFont,
		ClearTextOnFocus = false,
		MultiLine = true,
		TextWrapped = true,
	}, field)

	local api = elementApi(frame, page)
	api.Control = box
	api.Changed = new("BindableEvent", { Name = "LunaDarkChanged" })

	local function focusStyle(focused)
		if border and border.Parent then
			tween(border, {
				Color = focused and Config.Accent or Config.Stroke,
				Transparency = focused and 0.05 or 0.4,
			}, 0.12)
		end
	end

	box.Focused:Connect(function()
		focusStyle(true)
	end)
	box.FocusLost:Connect(function()
		focusStyle(false)
		if options.Callback then
			options.Callback(box.Text)
		end
		api.Changed:Fire(box.Text)
	end)

	function api:SetValue(text)
		box.Text = tostring(text or "")
		api.Changed:Fire(box.Text)
	end

	function api:GetValue()
		return box.Text
	end

	function api:GetText()
		return box.Text
	end

	function api:SetText(text)
		box.Text = tostring(text or "")
		api.Changed:Fire(box.Text)
	end

	function api:Clear()
		box.Text = ""
		api.Changed:Fire("")
	end

	function api:Focus()
		box:CaptureFocus()
	end

	function api:Blur()
		box:ReleaseFocus()
	end

	return api
end

-- ColorPicker: tres sliders RGB, campo hexadecimal y muestra del color.
-- Con Apply = true el acento de la libreria se cambia con el color elegido.
function Elements.ColorPicker(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local frame = makeRow(page, 92)

	local current = options.Default or Config.Accent
	local apply = options.Apply and true or false

	label(frame, {
		Size = UDim2.new(1, -60, 0, 15),
		Text = string.upper(tostring(options.Name or "Color")),
		TextSize = 11,
		Font = Config.MonoFont,
		TextColor3 = Config.Muted,
	}, "Muted")

	local preview = card(frame, UDim2.fromOffset(18, 18), UDim2.new(1, -36, 0, 18))
	round(preview, 2)
	outline(preview, Config.Stroke, 1, 0.2)
	new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = current,
		BorderSizePixel = 0,
	}, preview)

	local hexBox = new("TextBox", {
		Size = UDim2.new(0, 74, 0, 18),
		-- -36 - 18 - 74: 18px de margen exterior, 18px de la muestra de color
		-- y 18px de separacion. Sin sumar el ancho de la muestra, el campo
		-- terminaba justo encima de ella y esta se pegaba al borde.
		Position = UDim2.new(1, -128, 0, 18),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Config.Text,
		TextSize = 11,
		Font = Config.MonoFont,
		TextXAlignment = Enum.TextXAlignment.Right,
		ClearTextOnFocus = true,
	}, frame)

	local channels = { "R", "G", "B" }
	local sliders = {}
	local api = elementApi(frame, page)
	-- Muestra del color y campo hexadecimal, por si hay que leerlos o fijarlos.
	api.Swatch = preview
	api.HexBox = hexBox

	local function toHex()
		local r = math.floor(clamp(current.R, 0, 1) * 255 + 0.5)
		local g = math.floor(clamp(current.G, 0, 1) * 255 + 0.5)
		local b = math.floor(clamp(current.B, 0, 1) * 255 + 0.5)
		return string.format("%02X%02X%02X", r, g, b)
	end

	local function emit()
		preview.BackgroundColor3 = current
		hexBox.Text = toHex()
		if apply then
			lib:Theme({ Accent = current, Accent2 = current })
		end
		if options.Callback then
			options.Callback(current)
		end
	end

	for index = 1, 3 do
		local channel = channels[index]
		local track = card(frame, UDim2.new(1, -18, 0, 6), UDim2.fromOffset(8, 40 + (index - 1) * 12))
		local knob = new("Frame", {
			Size = UDim2.fromOffset(8, 12),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(clamp(current[channel], 0, 1), 0, 0.5, 0),
			BackgroundColor3 = current,
			BorderSizePixel = 0,
		}, track)
		round(knob, 2)
		outline(knob, Config.Stroke, 1, 0.2)
		sliders[index] = { Track = track, Knob = knob, Channel = channel }
	end

	local function setFromPointer(index, position)
		local entry = sliders[index]
		local size = entry.Track.AbsoluteSize.X
		if type(size) ~= "number" or size <= 0 then
			return
		end
		local ratio = clamp((position.X - entry.Track.AbsolutePosition.X) / size, 0, 1)
		current = Color3.new(
			channel == "R" and ratio or current.R,
			channel == "G" and ratio or current.G,
			channel == "B" and ratio or current.B
		)
		entry.Knob.Position = UDim2.new(ratio, 0, 0.5, 0)
		emit()
	end

	for index = 1, 3 do
		local entry = sliders[index]
		entry.Knob.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				setFromPointer(index, pointerPosition(input))
				api.dragCancel = beginDrag(function(move)
					setFromPointer(index, pointerPosition(move))
				end)
			end
		end)
	end

	hexBox.FocusLost:Connect(function()
		local text = string.gsub(tostring(hexBox.Text or ""), "#", "")
		local r = tonumber(string.sub(text, 1, 2), 16)
		local g = tonumber(string.sub(text, 3, 4), 16)
		local b = tonumber(string.sub(text, 5, 6), 16)
		if r and g and b then
			current = Color3.fromRGB(r, g, b)
			emit()
		else
			hexBox.Text = toHex()
		end
	end)

	hexBox.Text = toHex()

	function api:GetValue()
		return current
	end

	function api:SetValue(value)
		if type(value) == "table" and value.R then
			current = value
			emit()
		end
	end

	function api:SetText(text)
		hexBox.Text = tostring(text or "")
	end

	function api:GetText()
		return toHex()
	end

	return api
end

-- Info: tarjeta informativa con titulo y texto largo. No interactua.
function Elements.Info(page, nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local body = tostring(options.Text or "")
	local lines = 1
	-- Una linea de mas por cada salto: la altura crece con el texto.
	for _ in string.gmatch(body, "\n") do
		lines = lines + 1
	end
	local frame = makeRow(page, 18 + (lines * 14) + (options.Title and 16 or 0))

	local box = card(frame, UDim2.new(1, -16, 1, -4), UDim2.fromOffset(8, 2))
	outline(box, Config.Stroke, 1, 0.4)
	tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(2, 1),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, box))

	if options.Title then
		label(box, {
			Size = UDim2.new(1, -20, 0, 14),
			Position = UDim2.fromOffset(10, 7),
			Text = tostring(options.Title),
			TextSize = 12,
			TextColor3 = Config.Text,
		})
	end

	local textLabel = label(box, {
		Size = UDim2.new(1, -20, 1, -12),
		Position = UDim2.fromOffset(10, options.Title and 24 or 8),
		Text = tostring(options.Text or ""),
		TextSize = 11,
		TextColor3 = Config.Muted,
		Font = Config.MonoFont,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, "Muted")

	local api = elementApi(frame, page)
	api.TextLabel = textLabel

	function api:GetValue()
		return textLabel.Text
	end

	function api:SetValue(text)
		if textLabel.Parent then
			textLabel.Text = tostring(text or "")
		end
	end

	function api:GetText()
		return textLabel.Text
	end

	function api:SetText(text)
		if textLabel.Parent then
			textLabel.Text = tostring(text or "")
		end
	end

	return api
end

--[[ VENTANAS ]]--

function lib:CreateWindow(nameOrOptions, extra)
	local options = normalizeOptions(nameOrOptions, extra)
	local window = { _conns = {}, tabs = {}, scrollbars = {}, _relayout = {}, _overlays = {}, activeTab = nil, minimized = false }
	-- A partir de aqui (y hasta el final de la ventana) todas las esquinas
	-- redondeadas que se creen sin radio explicito son de esta ventana.
	buildingWindow = window
	function window:AddConnection(item)
		table.insert(self._conns, item)
		return function()
			for index = #self._conns, 1, -1 do
				if self._conns[index] == item then
					table.remove(self._conns, index)
				end
			end
		end
	end
	
	-- Referencia equilibrada: 800x600 deja espacio suficiente para el lateral,
	-- las cabeceras y varias filas sin forzar una densidad extrema.
	local width = options.Width or 800
	local height = options.Height or 600
	local cascade = #Windows * 26
	local restoreButton
	local restoreButtonWidth, restoreButtonHeight = 220, 72
	local restoreButtonText = tostring(options.RestoreButtonText or "LUNA")
	local restoreFPS = 0

	local function centerPosition(offsetX, offsetY)
		local size = viewport()
		local x = ((size.X / scaleValue) - width) / 2 + (offsetX or 0)
		local y = ((size.Y / scaleValue) - height) / 2 + (offsetY or 0)
		return UDim2.fromOffset(roundValue(x), roundValue(y))
	end

	local frame = new("Frame", {
		Name = "Window",
		Size = UDim2.fromOffset(width, height),
		Position = centerPosition(cascade, cascade),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Config.Panel,
		BorderSizePixel = 0,
		Active = true,
		ClipsDescendants = true,
	}, root)
	tag("Panel", frame)
	local screenSize = viewport()
	restoreButton = button(root, {
		Name = "LunaDarkRestoreButton",
		Size = UDim2.fromOffset(restoreButtonWidth, restoreButtonHeight),
		Position = UDim2.fromOffset(
			max(8, screenSize.X / scaleValue - restoreButtonWidth - 12),
			max(8, screenSize.Y / scaleValue - restoreButtonHeight - 12)
		),
		Text = "",
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = 10,
		TextColor3 = Config.Accent,
		Visible = false,
		Active = true,
		ZIndex = 100,
	})
	round(restoreButton, 4)
	outline(restoreButton, Config.Stroke, 1, 0.1)
	window.RestoreButton = restoreButton

	local function getRestorePing()
		local ok, value = pcall(function()
			return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		if ok and type(value) == "number" then
			return tostring(roundValue(value)) .. " ms"
		end
		ok, value = pcall(function()
			return StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString()
		end)
		if ok and value ~= nil then
			return tostring(value)
		end
		if LocalPlayer then
			ok, value = pcall(function()
				return LocalPlayer:GetNetworkPing()
			end)
			if ok and type(value) == "number" then
				return tostring(roundValue(value * 1000)) .. " ms"
			end
		end
		return "--"
	end

	local function refreshRestoreButtonText()
		local playerCount = 0
		local ok, roster = pcall(function()
			return Players:GetPlayers()
		end)
		if ok and type(roster) == "table" then
			playerCount = #roster
		end
		local playerText = tostring(playerCount)
		local maxOk, maxPlayers = pcall(function()
			return Players.MaxPlayers
		end)
		if maxOk and type(maxPlayers) == "number" and maxPlayers > 0 then
			playerText = playerText .. "/" .. tostring(maxPlayers)
		end
		restoreButton.Text = restoreButtonText
			.. "\nFPS: " .. tostring(restoreFPS)
			.. " | Ping: " .. getRestorePing()
			.. "\nJugadores: " .. playerText
	end

	refreshRestoreButtonText()
	window.FrameCorners = round(frame, styleState.Radius > 0 and (Config.Radius + 2) or 0)
	-- Sin halo: solo un borde de 1px, que es lo que da el look plano. En los
	-- estilos sin radio (Linea) el borde se apaga del todo.
	window.FrameStroke = new("UIStroke", {
		Color = Config.Stroke,
		Thickness = 1,
		Transparency = styleState.Radius > 0 and 0.1 or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, frame)

	local intro = new("UIScale", { Scale = 0.96 }, frame)
	window.Frame = frame

	-- Altura de la cabecera: 36 por defecto (barra compacta) o mas alta si el
	-- usuario pide una cabecera grande, como el bloque de titulo de las capturas.
	local barHeight = options.HeaderHeight or Config.BarHeight
	if type(barHeight) ~= "number" or barHeight < 24 then
		barHeight = Config.BarHeight
	end
	window.BarHeight = barHeight

	local bar = tag("Background", new("Frame", {
		Size = UDim2.new(1, 0, 0, barHeight),
		BackgroundColor3 = Config.Background,
		BorderSizePixel = 0,
		Active = true,
	}, frame))

	tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(6, 6),
		Position = UDim2.new(0, 14, 0.5, -1),
		AnchorPoint = Vector2.new(0, 0.5),
		Rotation = 45,
		BackgroundColor3 = Config.Accent,
		BorderSizePixel = 0,
	}, bar))

	-- En las capturas el titulo no empieza en el borde de la ventana sino
	-- alineado con la columna de contenido (a la derecha del lateral).
	-- El titulo queda a la izquierda del rombo superior.
	local titleX = options.TitleOffsetX
	if type(titleX) ~= "number" then
		titleX = 25
	end

	local titleLabel = label(bar, {
		Size = UDim2.new(0.45, -20, 0, 18),
		Position = UDim2.fromOffset(titleX, barHeight > 40 and math.floor(barHeight / 2) - 12 or 0),
		Text = tostring(options.Title or "LUNA"),
		Font = Config.MonoFont,
		TextSize = barHeight > 40 and 18 or 14,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local chip = new("Frame", {
		Size = UDim2.fromOffset(0, 20),
		Position = UDim2.new(1, -104, 0, 8),
		AnchorPoint = Vector2.new(1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Config.Card,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
	}, bar)
	round(chip, 3)
	local chipLabel = label(chip, {
		Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = "",
		TextColor3 = Config.Accent,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Config.MonoFont,
		TextSize = 11,
	}, "Accent")
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	}, chip)

	label(bar, {
		Size = UDim2.new(0.45, -20, 0, 14),
		Position = UDim2.fromOffset(titleX, barHeight > 40 and math.floor(barHeight / 2) + 8 or 18),
		Text = tostring(options.Subtitle or lib.Version),
		TextColor3 = Config.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Config.MonoFont,
		TextSize = 10,
	}, "Muted")

	-- Linea de 1px bajo la cabecera, solo sobre la columna de contenido: es la
	-- separacion nitida que se ve a 36px del borde superior en las capturas.
	if Config.Sidebar > 0 then
		new("Frame", {
			Size = UDim2.new(1, -Config.Sidebar, 0, 1),
			Position = UDim2.new(0, Config.Sidebar, 1, -1),
			BackgroundColor3 = Config.Stroke,
			BorderSizePixel = 0,
		}, bar)
	end

	local minimizeButton = button(bar, {
		Size = UDim2.fromOffset(24, 22),
		Position = UDim2.new(1, -58, 0.5, -11),
		Text = "-",
		TextSize = 13,
		TextColor3 = Config.Muted,
		Font = Config.MonoFont,
	})
	round(minimizeButton, 4)
	local closeButton = button(bar, {
		Size = UDim2.fromOffset(24, 22),
		Position = UDim2.new(1, -30, 0.5, -11),
		Text = "x",
		TextSize = 12,
		TextColor3 = Config.Muted,
		Font = Config.MonoFont,
	})
	round(closeButton, 4)

	local sidebar = tag("Background", new("Frame", {
		Size = UDim2.new(0, Config.Sidebar, 1, -barHeight),
		Position = UDim2.fromOffset(0, barHeight),
		BackgroundColor3 = Config.Background,
		BorderSizePixel = 0,
	}, frame))
	-- El separador vertical del lateral es la linea clara de 1px (#2F2E31 en las
	-- capturas), mas visible que el resto de lineas. No lleva UIScale: al
	-- escalar el lateral entero la linea se separaria del borde.
	tag("Divider", new("Frame", {
		Size = UDim2.fromOffset(1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = Config.Divider,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
	}, sidebar))

	local tabList = new("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -10),
		Position = UDim2.fromOffset(0, 8),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Config.Accent,
		ScrollBarImageTransparency = 0.3,
	}, sidebar)
	table.insert(window.scrollbars, tabList)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
	}, tabList)
	local tabLayout = new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
	}, tabList)
	-- El sidebar tambien debe poder alcanzar siempre el ultimo tab.
	local function updateTabCanvas()
		if tabList.Parent then
			local h = tabLayout.AbsoluteContentSize.Y + 8
			tabList.CanvasSize = UDim2.new(0, 0, 0, math.max(h, tabList.AbsoluteSize.Y + 1))
		end
	end
	window._tabCanvasUpdater = updateTabCanvas
	window:AddConnection(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas))
	window:AddConnection(tabList:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateTabCanvas))
	defer(0, updateTabCanvas)

	local statusHeight = options.StatusText and Config.StatusHeight or 0
	window.StatusHeight = statusHeight
	local content = tag("Panel", new("Frame", {
		Size = UDim2.new(1, -Config.Sidebar, 1, -barHeight - statusHeight),
		Position = UDim2.new(0, Config.Sidebar, 0, barHeight),
		BackgroundColor3 = Config.Panel,
		BorderSizePixel = 0,
	}, frame))
	window.content = content
	-- La cabecera y las paginas se apilan con un layout: si la cabecera se
	-- oculta (estilos sin Header) el espacio se recoge solo.
	new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0),
	}, content)

	-- Bloque de cabecera de la pagina: el rectangulo claro de 32px que hay bajo
	-- la barra en las capturas, con el nombre de la pestana y su descripcion.
	local pageHeader = tag("Card", new("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = Config.Card,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		Visible = styleState.Header and true or false,
	}, content))
	table.insert(headerBlocks, pageHeader)
	new("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Config.Divider,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
	}, pageHeader)
	local pageHeaderLabel = label(pageHeader, {
		Size = UDim2.new(1, -28, 0, 14),
		Position = UDim2.fromOffset(14, 5),
		Text = "",
		TextSize = 12,
		TextColor3 = Config.Text,
	}, "Text")
	local pageHeaderSub = label(pageHeader, {
		Size = UDim2.new(1, -28, 0, 12),
		Position = UDim2.fromOffset(14, 18),
		Text = "",
		TextSize = 9,
		TextColor3 = Config.Muted,
	}, "Muted")
	window.PageHeader = pageHeader
	window.PageHeaderLabel = pageHeaderLabel
	window.PageHeaderSub = pageHeaderSub

	-- Barra de estado: la franja clara de 6-7px del borde inferior en las capturas.
	if statusHeight > 0 then
		new("Frame", {
			Size = UDim2.new(1, 0, 0, statusHeight),
			Position = UDim2.new(0, 0, 1, -statusHeight),
			BackgroundColor3 = Config.Stroke,
			BackgroundTransparency = 0.35,
			BorderSizePixel = 0,
		}, frame)
		window.statusLabel = label(frame, {
			Size = UDim2.new(1, -16, 0, statusHeight),
			Position = UDim2.new(0, 8, 1, -statusHeight),
			Text = tostring(options.StatusText or ""),
			TextSize = 9,
			TextColor3 = Config.Muted,
			Font = Config.MonoFont,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, "Muted")
	end
	-- Se define siempre, exista la franja o no: si la ventana se creo sin
	-- StatusText, el primer SetStatusText la anade en vez de no hacer nada.
	function window:SetStatusText(text)
		if not self.statusLabel then
			local height = Config.StatusHeight
			if height <= 0 then
				height = 7
			end
			new("Frame", {
				Size = UDim2.new(1, 0, 0, height),
				Position = UDim2.new(0, 0, 1, -height),
				BackgroundColor3 = Config.Stroke,
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
			}, self.Frame)
			self.statusLabel = label(self.Frame, {
				Size = UDim2.new(1, -16, 0, height),
				Position = UDim2.new(0, 8, 1, -height),
				Text = "",
				TextSize = 9,
				TextColor3 = Config.Muted,
				Font = Config.MonoFont,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, "Muted")
			self.StatusHeight = height
			self:Relayout()
		end
		self.statusLabel.Text = tostring(text or "")
		return self
	end

	if Config.Scanline then
		local sweep = tag("Accent", new("Frame", {
			Size = UDim2.fromOffset(46, 0),
			Position = UDim2.fromOffset(-46, 0),
			BackgroundColor3 = Config.Accent,
			BackgroundTransparency = 0.88,
			BorderSizePixel = 0,
		}, bar))
		-- TweenInfo.new(time, estilo, direccion, repeatCount, reverses, delayTime)
		TweenService:Create(sweep, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 1.1), {
			Position = UDim2.fromOffset(width + 46, 0),
		}):Play()
	end

	local function clampPosition(position)
		local size = viewport()
		local maxX = (size.X / scaleValue) - width + 90
		local maxY = (size.Y / scaleValue) - Config.BarHeight
		return UDim2.new(
			0,
			clamp(position.X.Offset, -(width - 90), maxX),
			0,
			clamp(position.Y.Offset, 0, maxY)
		)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local startPointer = pointerPosition(input)
		local startPosition = frame.Position
		if window.dragCancel then
			window.dragCancel()
		end
		window.dragCancel = beginDrag(function(move)
			local delta = (pointerPosition(move) - startPointer) / scaleValue
			-- UDim2 + Vector2 no existe en Roblox: hay que sumar offset a offset
			frame.Position = clampPosition(UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			))
			window:Relayout()
		end)
	end)

	function window:AddRelayout(callback)
		table.insert(self._relayout, callback)
		return callback
	end

	function window:RemoveRelayout(callback)
		for index = #self._relayout, 1, -1 do
			if self._relayout[index] == callback then
				table.remove(self._relayout, index)
			end
		end
	end

	function window:Relayout()
		for index = 1, #self._relayout do
			self._relayout[index]()
		end
	end

	function window:AddOverlay(entry)
		table.insert(self._overlays, entry)
		return entry
	end

	function window:RemoveOverlay(entry)
		for index = #self._overlays, 1, -1 do
			if self._overlays[index] == entry then
				table.remove(self._overlays, index)
			end
		end
	end

	function window:CloseOverlays()
		for index = 1, #self._overlays do
			local entry = self._overlays[index]
			if entry and entry.Close then
				entry.Close()
			end
		end
	end

	function window:AddTabButton(name)
		local index = #self.tabs + 1
		-- 40px de alto con separador: la cadencia del lateral en las capturas.
		-- La densidad del estilo se aplica a la medida, no con un UIScale, para
		-- que el divisor del lateral siga pegado al borde.
		local itemHeight = tabMetrics(40)
		local itemText = tabMetrics(11)
		local tabButton = button(tabList, {
			Size = UDim2.new(1, 0, 0, itemHeight),
			Position = UDim2.fromOffset(0, 0),
			LayoutOrder = index,
			Text = tostring(name),
			TextColor3 = Config.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = itemText,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1,
		})
		round(tabButton, 0)
		hoverGhost(tabButton)
		new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 6) }, tabButton)
		-- Linea de 1px entre items del lateral (se apaga con los estilos sin
		-- separadores, igual que las lineas de las filas).
		local line = tag("Stroke", new("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Config.Stroke,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Visible = styleState.Separator and true or false,
		}, tabButton))
		table.insert(rowSeparators, line)
		table.insert(tabItems, { Frame = tabButton, Height = 40, TextSize = 11 })
		return { Frame = tabButton, Indicator = nil, Line = line, Name = tostring(name) }
	end

	function window:SelectTab(tab)
		self:CloseOverlays()
		for index = 1, #self.tabs do
			local entry = self.tabs[index]
			local active = entry.tab == tab
			entry.page.scroller.Visible = active
			tween(entry.button, {
				TextColor3 = active and Config.Accent or Config.Muted,
				BackgroundTransparency = (active and styleState.TabFill) or 1,
			}, Config.Anim)
			if entry.indicator then
				tween(entry.indicator, { BackgroundTransparency = active and 0 or 1 }, Config.Anim)
			end
		end
		self.activeTab = tab
		chipLabel.Text = tab and tab.Name or ""
		if self.PageHeaderLabel then
			self.PageHeaderLabel.Text = tab and tab.Name or ""
		end
		if self.PageHeaderSub then
			local subtitle = tab and tab.Subtitle
			self.PageHeaderSub.Text = (subtitle and subtitle ~= "") and subtitle or tostring(lib.Version)
		end
	end

	function window:AddTab(name)
		local page = {}
		local index = #self.tabs + 1
		local scroller = new("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Active = true,
			-- El canvas se calcula manualmente con AbsoluteContentSize.
			-- AutomaticCanvasSize puede quedarse corto cuando el contenedor usa UIScale.
			AutomaticCanvasSize = Enum.AutomaticSize.None,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Config.Accent,
			ScrollBarImageTransparency = 0.15,
			LayoutOrder = index,
			Visible = false,
		}, content)
		table.insert(self.scrollbars, scroller)

		page.order = 0
		page.scroller = scroller
		page.window = self
		page.container = new("Frame", {
			Size = UDim2.new(1, -Config.Gutter, 0, 0),
			Position = UDim2.fromOffset(Config.Gutter, 4),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, scroller)
		-- Densidad del estilo sobre el contenedor de filas: shrpea el texto y los
		-- huecos sin tocar el tamaño del scroll.
		local pageScale = new("UIScale", { Scale = styleState.Density }, page.container)
		table.insert(densityTargets, pageScale)
		page.scale = pageScale
		local rowLayout = new("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, styleState.RowPadding),
		}, page.container)
		table.insert(layoutTargets, rowLayout)
		page.layout = rowLayout

		-- Canvas de scroll robusto: toma la altura REAL del contenido, incluyendo
		-- el padding inferior. Esto evita que las ultimas opciones queden cortadas.
		local bottomPadding = 28
		local function updateCanvas()
			if not scroller.Parent or not page.container.Parent then
				return
			end

			-- AbsoluteContentSize puede no reflejar inmediatamente el UIScale del
			-- contenedor. Tomamos la mayor medida entre el layout y el contenedor
			-- ya calculado para que nunca falte espacio al final.
			local layoutHeight = rowLayout.AbsoluteContentSize.Y
			local containerHeight = page.container.AbsoluteSize.Y
			local contentHeight = math.max(layoutHeight, containerHeight) + bottomPadding

			-- CanvasSize siempre debe ser, como minimo, un pixel mayor que la
			-- ventana para que Roblox mantenga el ScrollingFrame operativo.
			scroller.CanvasSize = UDim2.new(
				0,
				0,
				0,
				math.max(contentHeight, scroller.AbsoluteSize.Y + 1)
			)
		end
		page.updateCanvas = updateCanvas
		self:AddConnection(rowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas))
		self:AddConnection(scroller:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas))
		self:AddConnection(page.container:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas))

		new("UIPadding", { PaddingBottom = UDim.new(0, bottomPadding) }, page.container)

		local tab = { _page = page, Name = tostring(name), Window = self }
		tab.Button = self:AddTabButton(name)
		self.TabItems = self.TabItems or {}
		table.insert(self.TabItems, tab.Button.Frame)
		self:AddConnection(tab.Button.Frame.Activated:Connect(function()
			self:SelectTab(tab)
		end))

		defer(0, function()
			if page.updateCanvas then
				page.updateCanvas()
			end
		end)

		function tab:Select()
			self.Window:SelectTab(self)
		end

		function tab:SetName(newName)
			self.Name = tostring(newName)
			self.Button.Frame.Text = self.Name
			if self.Window.activeTab == self then
				chipLabel.Text = self.Name
				if self.Window.PageHeaderLabel then
					self.Window.PageHeaderLabel.Text = self.Name
				end
			end
		end

		-- Descripcion corta que sale bajo el nombre en el bloque de cabecera.
		function tab:SetSubtitle(text)
			self.Subtitle = tostring(text or "")
			if self.Window.activeTab == self and self.Window.PageHeaderSub then
				self.Window.PageHeaderSub.Text = self.Subtitle
			end
		end

		function tab:AddSection(sectionName)
			local ok, result = pcall(function()
				-- Las secciones tienen mas jerarquia visual que las filas normales:
				-- 32px de base, texto 14px y tipografia fuerte. RowScale solo
				-- modifica proporcionalmente el alto, no el tamaño del texto.
				local frame = makeRow(page, 34)
				-- Marcador vertical/acento para que el titulo destaque sin ocupar
				-- demasiado ancho.
				tag("Accent", new("Frame", {
					Size = UDim2.fromOffset(3, 18),
					Position = UDim2.new(0, 0, 0.5, -9),
					BackgroundColor3 = Config.Accent,
					BorderSizePixel = 0,
				}, frame))
				label(frame, {
					Size = UDim2.new(1, -22, 1, 0),
					Position = UDim2.fromOffset(14, 0),
					Text = tostring(sectionName or "Seccion"),
					TextSize = 13,
					Font = Enum.Font.GothamBold,
					TextColor3 = Config.Text,
					TextYAlignment = Enum.TextYAlignment.Center,
				}, "Text")
				-- Linea de 1px con el color de divisor medido (#2F2E31).
				tag("Divider", new("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = Config.Divider,
					BackgroundTransparency = 0.25,
					BorderSizePixel = 0,
				}, frame))
				return installElementMethods({ _page = page, Window = self }, page)
			end)
			if not ok then
				warnElement("Section", result)
				return installElementMethods({ _page = page, Window = self }, page)
			end
			return result
		end

		local entry = {
			tab = tab,
			page = page,
			button = tab.Button.Frame,
			indicator = tab.Button.Indicator,
		}
		tab.entry = entry
		table.insert(self.tabs, entry)

		if not self.activeTab then
			self:SelectTab(tab)
		end
		return installElementMethods(tab, page)
	end

	function window:SetTitle(text)
		titleLabel.Text = tostring(text)
	end

	function window:SetVisible(isVisible)
		if not isVisible then
			self:CloseOverlays()
		end
		local visible = isVisible and true or false
		frame.Visible = visible
		restoreButton.Visible = not visible
	end

	function window:Toggle()
		self:SetVisible(not frame.Visible)
		return frame.Visible
	end

	function window:IsVisible()
		return frame.Visible
	end

	function window:SetRestoreButtonText(text)
		restoreButtonText = tostring(text or "")
		refreshRestoreButtonText()
	end

	--[[ API NUEVA DE VENTANA ]]--

	-- Opacidad de la ventana (0 = solida, 1 = invisible).
	function window:SetTransparency(value)
		local amount = clamp(value or 0, 0, 1)
		tween(frame, { BackgroundTransparency = amount }, Config.Anim)
	end

	-- Radio de las esquinas de la ventana (sigue al valor del estilo).
	-- Radio de las esquinas de ESTA ventana. Con nil vuelve al del estilo; antes
	-- de 1.3.0 era global y cualquier cambio de estilo lo pisaba.
	function window:SetRadius(value)
		if value == nil then
			self.Radius = nil
		else
			self.Radius = clamp(value, 0, 24)
		end
		for index = 1, #roundTargets do
			local entry = roundTargets[index]
			if entry and entry.Corner and entry.Corner.Parent and entry.Window == self then
				entry.Radius = self.Radius
				entry.Corner.CornerRadius = UDim.new(0, self.Radius or styleState.Radius)
			end
		end
		-- El marco de la ventana lleva su propio radio explicito.
		local marco, conBorde = frameBorder(self.Radius)
		if self.FrameCorners then
			self.FrameCorners.CornerRadius = UDim.new(0, marco)
		end
		-- El borde acompanya al marco: sin marco no hay nada que dibujar.
		if self.FrameStroke and self.FrameStroke.Parent then
			self.FrameStroke.Color = Config.Stroke
			self.FrameStroke.Transparency = conBorde and 0.1 or 1
		end
		self:Relayout()
		return self
	end

	-- Ancho y alto con rem minimo, sin romper el contenido.
	function window:Resize(newWidth, newHeight)
		local size = viewport()
		local targetWidth = clamp(math.floor(newWidth or self.fullWidth), 320, (size.X / scaleValue) - 20)
		local targetHeight = clamp(math.floor(newHeight or self.fullHeight), 180, (size.Y / scaleValue) - 20)
		self.fullWidth = targetWidth
		self.fullHeight = targetHeight
		width = targetWidth
		height = targetHeight
		if not self.minimized then
			tween(frame, { Size = UDim2.fromOffset(targetWidth, targetHeight) }, Config.Anim)
		end
		self:Relayout()
	end

	-- Pegar a un borde de la pantalla: "Left", "Right", "Top", "Bottom" o "Center".
	function window:Snap(side)
		local size = viewport()
		local usableWidth = size.X / scaleValue
		local usableHeight = size.Y / scaleValue
		local current = frame.Position
		local x, y = current.X.Offset, current.Y.Offset
		side = tostring(side or "Center"):lower()
		if side == "left" then
			x = 12
		elseif side == "right" then
			x = usableWidth - self.fullWidth - 12
		elseif side == "center" or side == "centro" then
			x = (usableWidth - self.fullWidth) / 2
		end
		if side == "top" or side == "arriba" then
			y = 12
		elseif side == "bottom" or side == "abajo" then
			y = usableHeight - self.fullHeight - 12
		elseif side == "center" or side == "centro" then
			y = (usableHeight - self.fullHeight) / 2
		end
		frame.Position = clampPosition(UDim2.fromOffset(roundValue(x), roundValue(y)))
		self:Relayout()
	end

	-- Abrir/cerrar con animacion de escala (la de entrada ya es automatica).
	function window:Animate(shouldOpen)
		local open = shouldOpen == nil and (not frame.Visible) or (shouldOpen and true or false)
		if open then
			frame.Visible = true
			restoreButton.Visible = false
			intro.Scale = 0.94
			tween(intro, { Scale = 1 }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			tween(frame, { BackgroundTransparency = 0 }, 0.2)
		else
			self:CloseOverlays()
			tween(intro, { Scale = 0.96 }, 0.14)
			tween(frame, { BackgroundTransparency = 1 }, 0.14)
			defer(0.16, function()
				if frame.Parent then
					frame.Visible = false
					frame.BackgroundTransparency = 0
					intro.Scale = 1
				end
			end)
			restoreButton.Visible = true
		end
		return open
	end

	-- Buscador: filtra las filas de la tab activa por nombre. "" = mostrar todo.
	function window:Search(query)
		local text = string.lower(tostring(query or ""))
		if not self.activeTab or not self.activeTab.page then
			return 0
		end
		local container = self.activeTab.page.container
		local shown = 0
		for index = 1, #container:GetChildren() do
			local row = container[index]
			if row:IsA("GuiObject") then
				local name = ""
				for childIndex = 1, #row:GetChildren() do
					local child = row[childIndex]
					if child:IsA("TextLabel") or child:IsA("TextButton") then
						name = string.lower(tostring(child.Text or ""))
						break
					end
				end
				local matches = text == "" or string.find(name, text, 1, true) ~= nil
				row.Visible = matches
				if matches then
					shown = shown + 1
				end
			end
		end
		self:Relayout()
		return shown
	end

	function window:Center()
		frame.Position = centerPosition(0, 0)
		self:Relayout()
	end

	function window:SetKeybind(key)
		if self.keyConnection then
			self.keyConnection:Disconnect()
			self.keyConnection = nil
		end
		if not key then
			return
		end
		self.keyConnection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed or input.KeyCode ~= key or UserInputService:GetFocusedTextBox() then
				return
			end
			self:SetVisible(not frame.Visible)
		end)
		self:AddConnection(function()
			if self.keyConnection then
				self.keyConnection:Disconnect()
			end
		end)
	end

	local restoreDragCancel
	local restoreWasDragged = false
	window:AddConnection(restoreButton.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		restoreWasDragged = false
		if restoreDragCancel then
			restoreDragCancel()
			restoreDragCancel = nil
		end
		local startPointer = pointerPosition(input)
		local startPosition = restoreButton.Position
		restoreDragCancel = beginDrag(function(move)
			local delta = (pointerPosition(move) - startPointer) / scaleValue
			if abs(delta.X) > 4 or abs(delta.Y) > 4 then
				restoreWasDragged = true
			end
			local size = viewport()
			local maxX = max(0, size.X / scaleValue - restoreButtonWidth)
			local maxY = max(0, size.Y / scaleValue - restoreButtonHeight)
			restoreButton.Position = UDim2.fromOffset(
				clamp(startPosition.X.Offset + delta.X, 0, maxX),
				clamp(startPosition.Y.Offset + delta.Y, 0, maxY)
			)
		end, function()
			restoreDragCancel = nil
		end)
	end))
	window:AddConnection(restoreButton.Activated:Connect(function()
		if restoreWasDragged then
			restoreWasDragged = false
			return
		end
		window:SetVisible(true)
	end)) 
	window:AddConnection(Players.PlayerAdded:Connect(function()
		if restoreButton.Visible then
			refreshRestoreButtonText()
		end
	end))
	window:AddConnection(Players.PlayerRemoving:Connect(function()
		if restoreButton.Visible then
			refreshRestoreButtonText()
		end
	end))
	window:AddConnection(function()
		if restoreDragCancel then
			restoreDragCancel()
			restoreDragCancel = nil
		end
		restoreButton:Destroy()
	end)
	-- El contador de FPS/ping lo actualiza el bombillo compartido una vez por
	-- segundo, y solo si la ventana esta visible: si no, no hay trabajo que hacer.
	window.pump = {
		tick = function(fps)
			restoreFPS = fps
			if restoreButton.Visible then
				refreshRestoreButtonText()
			end
		end,
	}
	table.insert(pumpTargets, window.pump)
	acquirePump()
	window:AddConnection(function()
		releasePump(window.pump)
	end)

	-- RightShift oculta/muestra la ventana por defecto; se puede sustituir con SetKeybind.
	window:SetKeybind(options.Keybind == nil and Enum.KeyCode.RightShift or options.Keybind)

	function window:Minimize(isMinimized)
		self.minimized = isMinimized == nil and (not self.minimized) or (isMinimized and true or false)
		local target = self.minimized and barHeight or self.fullHeight
		minimizeButton.Text = self.minimized and "+" or "-"
		if self.minimized then
			self:CloseOverlays()
		end
		tween(frame, { Size = UDim2.new(0, self.fullWidth, 0, target) }, Config.Anim)
	end

	closeButton.MouseEnter:Connect(function()
		tween(closeButton, { BackgroundColor3 = Color3.fromRGB(180, 55, 65) }, Config.Anim)
	end)
	closeButton.MouseLeave:Connect(function()
		tween(closeButton, { BackgroundColor3 = Config.Card }, Config.Anim)
	end)
	minimizeButton.MouseEnter:Connect(function()
		tween(minimizeButton, { BackgroundColor3 = Color3.fromRGB(70, 80, 100) }, Config.Anim)
	end)
	minimizeButton.MouseLeave:Connect(function()
		tween(minimizeButton, { BackgroundColor3 = Config.Card }, Config.Anim)
	end)
	closeButton.Activated:Connect(function()
		window:Destroy()
	end)
	minimizeButton.Activated:Connect(function()
		window:SetVisible(false)
	end)

	function window:Destroy()
		if self.dragCancel then
			self.dragCancel()
			self.dragCancel = nil
		end
		self:CloseOverlays()
		local conns = {}
		for index = 1, #self._conns do
			conns[index] = self._conns[index]
		end
		clearTable(self._conns)
		for index = 1, #conns do
			local item = conns[index]
			if type(item) == "function" then
				item()
			else
				item:Disconnect()
			end
		end
		clearTable(self._relayout)
		clearTable(self._overlays)
		for index = #Windows, 1, -1 do
			if Windows[index] == self then
				table.remove(Windows, index)
			end
		end
		tween(intro, { Scale = 0.92 }, 0.12)
		tween(frame, { BackgroundTransparency = 1 }, 0.12)
		defer(0.14, function()
			if frame.Parent then
				frame:Destroy()
			end
		end)
	end

	window.fullWidth = width
	window.fullHeight = height

	tween(intro, { Scale = 1 }, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	tween(frame, { BackgroundTransparency = 0 }, 0.24)

	table.insert(Windows, window)
	return window
end

--[[ NOTIFICACIONES ]]--

local toastTypes = {
	info = { label = "i", color = nil },
	success = { label = "v", color = Color3.fromRGB(80, 220, 130) },
	warn = { label = "!", color = Color3.fromRGB(255, 190, 70) },
	error = { label = "x", color = Color3.fromRGB(255, 90, 100) },
}

local toasts = {}
local toastHeight = 66

local function restackToasts()
	local offset = 20
	for index = #toasts, 1, -1 do
		local toast = toasts[index]
		tween(toast.Frame, {
			Position = UDim2.new(1, -24, 1, -offset),
		}, 0.2)
		offset = offset + toastHeight + 10
	end
end

function lib:Notify(nameOrOptions, extra)
	local options
	if type(nameOrOptions) == "string" then
		options = { Title = nameOrOptions, Text = extra }
	else
		options = nameOrOptions or extra or {}
	end
	local kind = toastTypes[options.Type or "info"] or toastTypes.info

	local toast = card(toastLayer, UDim2.fromOffset(300, toastHeight), UDim2.new(1, 40, 1, -20), "Frame")
	toast.AnchorPoint = Vector2.new(1, 1)
	toast.ZIndex = 45
	outline(toast, Config.Stroke, 1, 0.25)

	local bar = tag("Accent", new("Frame", {
		Size = UDim2.fromOffset(3, toastHeight - 16),
		Position = UDim2.fromOffset(7, 8),
		BackgroundColor3 = kind.color or Config.Accent,
		BorderSizePixel = 0,
	}, toast))
	round(bar, 2)

	new("TextLabel", {
		Size = UDim2.fromOffset(20, 20),
		Position = UDim2.fromOffset(18, 10),
		BackgroundTransparency = 1,
		Text = kind.label,
		TextColor3 = kind.color or Config.Accent,
		Font = Config.MonoFont,
		TextSize = 14,
		ZIndex = 46,
	}, toast)

	label(toast, {
		Size = UDim2.new(1, -46, 0, 18),
		Position = UDim2.fromOffset(44, 9),
		Text = tostring(options.Title or "Luna"),
		TextSize = 13,
		ZIndex = 46,
	})

	label(toast, {
		Size = UDim2.new(1, -24, 0, 32),
		Position = UDim2.fromOffset(18, 28),
		Text = tostring(options.Text or ""),
		TextSize = 12,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = Config.Muted,
		Font = Config.MonoFont,
		ZIndex = 46,
	}, "Muted")

	local entry = { Frame = toast }
	table.insert(toasts, entry)

	-- Barra de tiempo: se encoge con el tiempo que le queda al toast. Se anima
	-- con TweenService (sin bucles por frame).
	local duration = tonumber(options.Duration) or 3
	local progressTrack = new("Frame", {
		Size = UDim2.new(1, -16, 0, 1),
		Position = UDim2.fromOffset(8, toastHeight - 6),
		BackgroundColor3 = Config.Stroke,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		ZIndex = 46,
	}, toast)
	local progressFill = tag("Accent", new("Frame", {
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = kind.color or Config.Accent,
		BorderSizePixel = 0,
		ZIndex = 47,
	}, progressTrack))
	if duration > 0 then
		tween(progressFill, { Size = UDim2.fromScale(0, 1) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	end
	entry.ProgressFill = progressFill

	local function removeToast(target)
		if target.Removed or not target.Frame.Parent then
			return
		end
		target.Removed = true
		for index = #toasts, 1, -1 do
			if toasts[index] == target then
				table.remove(toasts, index)
				break
			end
		end
		tween(target.Frame, {
			Position = UDim2.new(1, 340, 1, target.Frame.Position.Y.Offset),
		}, 0.18)
		defer(0.2, function()
			if target.Frame.Parent then
				target.Frame:Destroy()
			end
		end)
		restackToasts()
	end

	restackToasts()

	while #toasts > (Config.ToastLimit or 4) do
		removeToast(toasts[1])
	end

	defer(options.Duration or 3, function()
		removeToast(entry)
	end)
	return { Close = function() removeToast(entry) end, Frame = toast }
end

-- Cierra todos los avisos vivos de golpe.
function lib:ClearToasts()
	local snapshot = {}
	for index = 1, #toasts do
		snapshot[index] = toasts[index]
	end
	for index = 1, #snapshot do
		local toast = snapshot[index]
		if toast and not toast.Removed and toast.Frame then
			toast.Removed = true
			if toast.Frame.Parent then
				toast.Frame:Destroy()
			end
		end
	end
	clearTable(toasts)
end

--[[ TEMA ]]--

	function lib:Style(style)
		if type(style) == "string" then
			style = StylePresets[style] or styleLookup[string.lower(style)]
		end
		if type(style) ~= "table" then
			return false
		end
		-- Primero los valores por defecto, luego los del estilo: asi un preset
		-- que no declara una clave no hereda el valor del estilo anterior.
		for key, value in pairs(StyleDefaults) do
			styleState[key] = value
		end
		for key, value in pairs(style) do
			if StyleDefaults[key] ~= nil then
				styleState[key] = value
			end
		end
		applyStyle()
		return true
	end

function lib:GetStyle()
	return styleState
end

function lib:Theme(theme)
	if type(theme) == "string" then
		theme = Themes[theme] or themeLookup[string.lower(theme)]
	end
	if type(theme) ~= "table" then
		return false
	end
	for key, value in pairs(theme) do
		if Config[key] ~= nil then
			Config[key] = value
		end
	end
	for role, instances in pairs(tint) do
		local color = Config[role]
		for index = 1, #instances do
			local object = instances[index]
			if object and object.Parent then
				if object:IsA("UIGradient") then
					object.Color = ColorSequence.new(color, Config.Accent2)
				elseif object:IsA("UIStroke") then
					object.Color = color
				elseif object:IsA("TextLabel") or role == "Text" or role == "Muted" then
					object.TextColor3 = color
				else
					object.BackgroundColor3 = color
				end
			end
		end
	end
	for index = 1, #Windows do
		local window = Windows[index]
		for tabIndex = 1, #window.tabs do
			local entry = window.tabs[tabIndex]
			local active = window.activeTab == entry.tab
			-- Reemplaza cualquier tween de seleccion anterior que aun use el color viejo.
			tween(entry.button, {
				TextColor3 = active and Config.Accent or Config.Muted,
			}, Config.Anim)
		end
		if window.RestoreButton then
			window.RestoreButton.BackgroundColor3 = Config.Card
			window.RestoreButton.TextColor3 = Config.Accent
		end
		for position = 1, #window.scrollbars do
			window.scrollbars[position].ScrollBarImageColor3 = Config.Accent
		end
	end
	return true
end

--[[ UTILIDADES PUBLICAS ]]--

function lib:ToggleAll()
	local anyVisible = false
	for index = 1, #Windows do
		if Windows[index].Frame.Visible then
			anyVisible = true
			break
		end
	end
	for index = 1, #Windows do
		Windows[index].Frame.Visible = not anyVisible
	end
end

function lib:Unload()
	for index = #Windows, 1, -1 do
		Windows[index]:Destroy()
	end
	clearTable(Windows)
	if screen and screen.Parent then
		screen:Destroy()
	end
end

function lib:GetWindows()
	return Windows
end

function lib:GetAccent()
	return Config.Accent
end

-- En executors deja la libreria accesible con getgenv().LunaDarkUI.
if type(getgenv) == "function" then
	local ok, env = pcall(getgenv)
	if ok and type(env) == "table" then
		env.LunaDarkUI = lib
	end
end


return lib
