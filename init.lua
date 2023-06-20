AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    
    self:SetModel("models/props_c17/FurnitureWashingmachine001a.mdl") 
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE) -- you can change this to MOVETYPE_VPHYSICS for it to move freely 

   
    self.collidedObjectData = nil

    
    self.spawnDelay = 5
    self.nextSpawnTime = 0
end

function ENT:PhysicsCollide(data, phys)

    local collidedEntity = data.HitEntity

  
    if IsValid(collidedEntity) and collidedEntity:GetClass() == "prop_physics" and self:CanSpawn() then
        Entity(1):EmitSound("weapons/smg1/switch_single.wav")
        self.collidedObjectData = {
            model = collidedEntity:GetModel(),
            position = collidedEntity:GetPos(),
            angles = collidedEntity:GetAngles()
        }

    
        self.nextSpawnTime = CurTime() + self.spawnDelay

    
        collidedEntity:Remove()
    end
end

function ENT:Think()

    if self.collidedObjectData and CurTime() >= self.nextSpawnTime then

        local duplicatedObject = ents.Create("prop_physics")
        if IsValid(duplicatedObject) then
            duplicatedObject:SetModel(self.collidedObjectData.model)
            duplicatedObject:SetPos(self:GetPos() + self:GetForward() * 50) 
            duplicatedObject:SetAngles(self.collidedObjectData.angles)
            duplicatedObject:Spawn()
        end

        
        self.nextSpawnTime = CurTime() + self.spawnDelay
    end

 
    self:NextThink(CurTime())
    return true
end

function ENT:CanSpawn()
    return CurTime() >= self.nextSpawnTime
end
