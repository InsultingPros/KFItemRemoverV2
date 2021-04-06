class KFItemRemoverV2 extends Mutator
	config(KFItemRemoverV2);

var config array< class<Pickup> > RemovedClasses;

function bool IsRemoved(Class C) {
	local int i;
	
	if (class<Pickup>(C) == None) {
		return false;
	}
	
	for (i = 0; i < RemovedClasses.length; i++) {
		if (RemovedClasses[i] == C) {
			return true;
		}
	}
	
	return false;
}

function PostBeginPlay() {
	Super.PostBeginPlay();
	SetTimer(1.0, false);
}

function Timer() {
	local KFLevelRules LR;
	local int i;

	foreach DynamicActors(class'KFLevelRules', LR) {
		break;
	}
	
	if (LR != None) {
		for (i = 0; i < LR.MediItemForSale.length; i++) {
			if (IsRemoved(LR.MediItemForSale[i])) {
				LR.MediItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.SuppItemForSale.length; i++) {
			if (IsRemoved(LR.SuppItemForSale[i])) {
				LR.SuppItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.ShrpItemForSale.length; i++) {
			if (IsRemoved(LR.ShrpItemForSale[i])) {
				LR.ShrpItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.CommItemForSale.length; i++) {
			if (IsRemoved(LR.CommItemForSale[i])) {
				LR.CommItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.BersItemForSale.length; i++) {
			if (IsRemoved(LR.BersItemForSale[i])) {
				LR.BersItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.FireItemForSale.length; i++) {
			if (IsRemoved(LR.FireItemForSale[i])) {
				LR.FireItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.DemoItemForSale.length; i++) {
			if (IsRemoved(LR.DemoItemForSale[i])) {
				LR.DemoItemForSale[i] = None;
			}
		}
		
		for (i = 0; i < LR.NeutItemForSale.length; i++) {
			if (IsRemoved(LR.NeutItemForSale[i])) {
				LR.NeutItemForSale[i] = None;
			}
		}
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if (Pickup(Other) != None && IsRemoved(Other.Class)) {
		ReplaceWith(Other, "None");
		return false;
	}
	else if (Inventory(Other) != None && IsRemoved(Inventory(Other).PickupClass)) {
		ReplaceWith(Other, "None");
		return false;
	}
	 
	return Super.CheckReplacement(Other, bSuperRelevant);
}

function ModifyPlayer(Pawn Other) {
	local Inventory Inv;
	local int i;
	
	if (Other != None) {
		for (i = 0; i < RemovedClasses.length; i++) {
			for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory) {
				if (RemovedClasses[i] == Inv.PickupClass) {
					Inv.Destroyed();
					Inv.Destroy();
					break;
				}
			}
		}
	}
	
	Super.ModifyPlayer(Other);
}

defaultproperties {
	GroupName="KFItemRemoverV2"
	FriendlyName="Item Remover V2"
	Description="Removes selected items from the game."
}