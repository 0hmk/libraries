--made by im.kyu in 20 mins
local camera, esp, objects = workspace.CurrentCamera, {
	objects = {
			line = {},
			text = {}		
		}
	};
function create(i)
	local obj = Instance.new(i)
		return function(a)	
		for i,v in pairs(a) do
			obj[i] = v
		end
		return obj
	end
end
do
	function esp:new()
		local self = setmetatable({},{__index = esp});
		return self
	end
	function esp:highlight(obj,config)
		config = config or {FillTransparency = 0}
		config.Adornee = obj;
		config.Parent = game:GetService("CoreGui")
		return create "Highlight" (config)
	end
	function esp:draw(type, ...)
		local obj = Drawing.new(type);
		obj.Visible = false;
		obj.Transparency = 1;
		table.insert(self.objects[type:lower()], {obj, ...})
		return #self.objects[type:lower()]
	end
	function esp:remove(type, idx)
		self.objects[type:lower()][idx]:Remove();
		self.objects[type:lower()][idx] = nil;
	end
	function esp:startRendering()
		local con;
		con = game:service'RunService'.RenderStepped:Connect(function()
			for i,v in pairs(self.objects.line) do
				local line, object, check, getcolor = v[1], v[2], v[3], v[4];
				local vector, onScreen = camera:WorldToViewportPoint(object.Position)
				if onScreen and check() then
					line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2);
					line.To = Vector2.new(vector.X, vector.Y)
					line.Color = getcolor()
					line.Visible = true
				else
					line.Visible = false
				end
			end
			for i,v in pairs(self.objects.text)do
				local text, object, check, getcolor, gettext = v[1], v[2], v[3], v[4], v[5];
				for i,v in pairs(v[6] or {
					Size = 14,
					Center = true,
					Font = 3,
					OutlineColor = Color3.new(0,0,0),
					Outline = true
				})do
					text[i] = v
				end
				local vector, onScreen = camera:WorldToViewportPoint(object.Position)
				if onScreen and check() then
					text.Position = Vector2.new(vector.X, vector.Y)
					text.Color = getcolor()
					text.Text = gettext()
					text.Visible = true
				else
					text.Visible = false
				end
			end
		end)
		self.connection = con;
	end
	function esp:updateRendering()
		self.connection:Disconnect();
		self:startRendering();
	end
	function esp:stopRendering()
		self.connection:Disconnect();
	end
	function esp:disable()
		for i,v in pairs(self.objects)do
			for a,b in pairs(v)do
				b[1]:Remove();
			end
		end
	end
end
return esp;
