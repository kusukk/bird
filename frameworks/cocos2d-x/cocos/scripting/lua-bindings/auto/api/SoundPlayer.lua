
--------------------------------
-- @module SoundPlayer
-- @extend Ref
-- @parent_module mybo

--------------------------------
-- 
-- @function [parent=#SoundPlayer] stopAllEffects 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] playBackgroundMusic 
-- @param self
-- @param #char musicId
-- @param #bool isMileuBg
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] getEffectsVolume 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] setSFXEnbale 
-- @param self
-- @param #bool enable
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] stopEffect 
-- @param self
-- @param #unsigned int nSoundId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] pauseBackgroundMusic 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] willPlayBackgroundMusic 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] setBackgroundMusicVolume 
-- @param self
-- @param #float volume
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] stopBackgroundMusic 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] getBackgroundMusicVolume 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] isBackgroundMusicPlaying 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] init 
-- @param self
-- @param #string config
-- @param #bool disableMusic
-- @param #bool disableSFX
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] unloadEffect 
-- @param self
-- @param #char sfxId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] stopAudioByGroup 
-- @param self
-- @param #char groupId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] loadSound 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] pauseAllEffects 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] preloadBackgroundMusic 
-- @param self
-- @param #char musicId
-- @param #bool isSecondSound
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] loadSoundCallBack 
-- @param self
-- @param #float dt
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] getMusicEnbale 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] playEffect 
-- @param self
-- @param #char SFXId
-- @return unsigned int#unsigned int ret (return value: unsigned int)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] preloadEffectForId 
-- @param self
-- @param #string sfxId
-- @param #function callback
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] resumeAllEffects 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] unloadEffectForId 
-- @param self
-- @param #char sfxId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] getSFXEnbale 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] rewindBackgroundMusic 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] preloadEffect 
-- @param self
-- @param #char sfxId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] playBalloonBlast 
-- @param self
-- @param #float time
-- @param #int number
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] resumeAudioByGroup 
-- @param self
-- @param #char groupId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] pauseEffect 
-- @param self
-- @param #unsigned int nSoundId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] resumeBackgroundMusic 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] setMusicEnbale 
-- @param self
-- @param #bool enable
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] changEffectsLoading 
-- @param self
-- @param #bool inMapScene
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] setEffectsVolume 
-- @param self
-- @param #float volume
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] resumeEffect 
-- @param self
-- @param #unsigned int nSoundId
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] getInstance 
-- @param self
-- @return SoundPlayer#SoundPlayer ret (return value: SoundPlayer)
        
--------------------------------
-- 
-- @function [parent=#SoundPlayer] SoundPlayer 
-- @param self
-- @return SoundPlayer#SoundPlayer self (return value: SoundPlayer)
        
return nil
