  {-# OPTIONS -fglasgow-exts #-}
-----------------------------------------------------------------------------------------
{-| Module      :  Events
    Copyright   :  (c) Daan Leijen 2003
    License     :  wxWindows

    Maintainer  :  daan@cs.uu.nl
    Stability   :  provisional
    Portability :  portable

    Events.
-}
-----------------------------------------------------------------------------------------
module Graphics.UI.WXH.Events
        (
        -- * Set event handlers
        -- ** Controls
          buttonOnCommand
        , checkBoxOnCommand
        , choiceOnCommand
        , comboBoxOnCommand
        , controlOnText
        , listBoxOnCommand
        -- , listBoxOnDClick
        , radioBoxOnCommand
        , sliderOnCommand
        , textCtrlOnTextEnter

        -- ** Windows
        , windowOnMouse
        , windowOnKeyChar
        , windowOnKeyDown
        , windowOnKeyUp
        , windowOnClose
        , windowOnDestroy
        , windowAddOnDelete
        , windowOnDelete
        , windowOnCreate
        , windowOnIdle
        , windowOnTimer
        , windowOnSize
        , windowOnFocus
        , windowOnActivate
        , windowOnPaint
        , windowOnContextMenu
        , windowOnScroll

        -- ** Event handlers
        , evtHandlerOnMenuCommand
        , evtHandlerOnEndProcess
        , evtHandlerOnInput
        , evtHandlerOnInputSink

        -- * Get event handlers
        -- ** Controls
        , buttonGetOnCommand
        , checkBoxGetOnCommand
        , choiceGetOnCommand
        , comboBoxGetOnCommand
        , controlGetOnText
        , listBoxGetOnCommand
        -- , listBoxGetOnDClick
        , radioBoxGetOnCommand
        , sliderGetOnCommand
        , textCtrlGetOnTextEnter

        -- ** Windows
        , windowGetOnMouse
        , windowGetOnKeyChar
        , windowGetOnKeyDown
        , windowGetOnKeyUp
        , windowGetOnClose
        , windowGetOnDestroy
        , windowGetOnDelete
        , windowGetOnCreate
        , windowGetOnIdle
        , windowGetOnTimer
        , windowGetOnSize
        , windowGetOnFocus
        , windowGetOnActivate
        , windowGetOnPaint
        , windowGetOnContextMenu
        , windowGetOnScroll

        -- ** Event handlers
        , evtHandlerGetOnMenuCommand
        , evtHandlerGetOnEndProcess
        , evtHandlerGetOnInputSink

        -- * Timers
        , windowTimerAttach
        , windowTimerCreate
        , timerOnCommand
        , timerGetOnCommand

        -- * Types
        -- ** Streams
        , StreamStatus(..), streamStatusFromInt

        -- ** Modifiers
        , Modifiers(..)
        , showModifiers
        , noneDown, justShift, justAlt, justControl, justMeta, isNoneDown

        -- ** Mouse events
        , EventMouse (..)
        , showMouse
        , mousePos, mouseModifiers

        -- ** Keyboard events
        , EventKey (..), Key(..)
        , keyKey, keyModifiers, keyPos
        , showKey, showKeyModifiers

        -- ** Scroll events
        , EventScroll(..), Orientation(..)
        , scrollOrientation, scrollPos

        -- * Current event
        , skipCurrentEvent
        , withCurrentEvent

        -- * Primitive
        , appOnInit

        -- ** Client data
        , objectWithClientData
        , objectSetClientData

        -- ** Input sink
        , inputSinkEventLastString

        -- ** Keys
        , KeyCode
        , modifiersToAccelFlags
        , keyCodeToKey, keyToKeyCode

        -- ** Events
        , windowOnEvent, windowOnEventEx

        -- ** Generic
        , OnEvent
        , evtHandlerOnEvent
        , evtHandlerOnEventConnect

        -- ** Unsafe
        , unsafeObjectGetClientData
        , unsafeGetHandlerState
        , unsafeWindowGetHandlerState
        ) where

import List( intersperse )
import System.Environment( getProgName, getArgs )
import Foreign.StablePtr
import Foreign.Ptr
import Foreign.C.String
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array

import Control.Concurrent.MVar
import System.IO.Unsafe( unsafePerformIO )

import qualified Graphics.UI.WXH.IntMap as IntMap
import Graphics.UI.WXH.WxcTypes
import Graphics.UI.WXH.WxcDefs
import Graphics.UI.WXH.WxcClasses
import Graphics.UI.WXH.Types
import Graphics.UI.WXH.Draw

------------------------------------------------------------------------------------------
-- Controls  (COMMAND events)
------------------------------------------------------------------------------------------
-- | Set an event handler for a push button.
buttonOnCommand :: Button a -> IO () -> IO ()
buttonOnCommand button eventHandler
  = windowOnEvent button [wxEVT_COMMAND_BUTTON_CLICKED] eventHandler (\evt -> eventHandler)


-- | Get the current button event handler on a window.
buttonGetOnCommand :: Window a -> IO (IO ())
buttonGetOnCommand button
  = unsafeWindowGetHandlerState button wxEVT_COMMAND_BUTTON_CLICKED skipCurrentEvent


-- | Set an event handler for "updated text", works for example on a 'TextCtrl' and 'ComboBox'.
controlOnText :: Control a -> IO () -> IO ()
controlOnText control eventHandler
  = windowOnEvent control [wxEVT_COMMAND_TEXT_UPDATED] eventHandler (\evt -> eventHandler)

-- | Get the current event handler for updated text.
controlGetOnText :: Control a -> IO (IO ())
controlGetOnText control
  = unsafeWindowGetHandlerState control wxEVT_COMMAND_TEXT_UPDATED skipCurrentEvent


-- | Set an event handler for an enter command in a text control.
textCtrlOnTextEnter :: TextCtrl a -> IO () -> IO ()
textCtrlOnTextEnter textCtrl eventHandler
  = windowOnEvent textCtrl [wxEVT_COMMAND_TEXT_ENTER] eventHandler (\evt -> eventHandler)

-- | Get the current text enter event handler.
textCtrlGetOnTextEnter :: TextCtrl a -> IO (IO ())
textCtrlGetOnTextEnter textCtrl
  = unsafeWindowGetHandlerState textCtrl wxEVT_COMMAND_TEXT_ENTER skipCurrentEvent

{-
-- | Set an event handler for when a user tries to type more than than the maximally
-- allowed text in a text control.
textCtrlOnTextMaxLen :: IO () -> TextCtrl a -> IO ()
textCtrlOnTextMaxLen eventHandler textCtrl
  = windowOnEvent textCtrl [wxEVT_COMMAND_TEXT_MAXLEN] eventHandler (\evt -> eventHandler)

-- | Get the current maximal text event handler.
textCtrlGetOnTextMaxLen :: TextCtrl a -> IO (IO ())
textCtrlGetOnTextMaxLen textCtrl
  = unsafeWindowGetHandlerState textCtrl wxEVT_COMMAND_TEXT_MAXLEN skipCurrentEvent
-}

-- | Set an event handler for when a combo box item is selected.
comboBoxOnCommand :: ComboBox a -> IO () -> IO ()
comboBoxOnCommand comboBox eventHandler
  = windowOnEvent comboBox [wxEVT_COMMAND_COMBOBOX_SELECTED] eventHandler (\evt -> eventHandler)

-- | Get the current combo box event handler for selections
comboBoxGetOnCommand :: ComboBox a -> IO (IO ())
comboBoxGetOnCommand comboBox
  = unsafeWindowGetHandlerState comboBox wxEVT_COMMAND_COMBOBOX_SELECTED skipCurrentEvent

-- | Set an event handler for when a listbox item is (de)selected.
listBoxOnCommand :: ListBox a -> IO () -> IO ()
listBoxOnCommand listBox eventHandler
  = windowOnEvent listBox [wxEVT_COMMAND_LISTBOX_SELECTED] eventHandler (\evt -> eventHandler)

-- | Get the current listbox event handler for selections.
listBoxGetOnCommand :: ListBox a -> IO (IO ())
listBoxGetOnCommand listBox
  = unsafeWindowGetHandlerState listBox wxEVT_COMMAND_LISTBOX_SELECTED skipCurrentEvent

{-
-- | Set an event handler for when a listbox item is double clicked. Takes the selected
-- item index as an argument.
listBoxOnDClick :: (Int -> IO ()) -> ListBox a -> IO ()
listBoxOnDClick eventHandler listBox
  = windowOnEvent listBox [wxEVT_COMMAND_LISTBOX_DCLICK] eventHandler dclickHandler
  where
    dclickHandler event
      = do index <- commandEventGetInt (objectCast event)
           eventHandler index

-- | Get the current double click listbox event handler.
listBoxGetOnDClick :: ListBox a -> IO (IO ())
listBoxGetOnDClick listBox
  = unsafeWindowGetHandlerState listBox wxEVT_COMMAND_LISTBOX_DCLICK (\index -> skipCurrentEvent)
-}

-- | Set an event handler for when a choice item is (de)selected.
choiceOnCommand :: Choice a -> IO () -> IO ()
choiceOnCommand choice eventHandler
  = windowOnEvent choice [wxEVT_COMMAND_CHOICE_SELECTED] eventHandler (\evt -> eventHandler)

-- | Get the current choice command event handler.
choiceGetOnCommand :: Choice a -> IO (IO ())
choiceGetOnCommand choice
  = unsafeWindowGetHandlerState choice wxEVT_COMMAND_CHOICE_SELECTED skipCurrentEvent


-- | Set an event handler for when a radiobox item is selected.
radioBoxOnCommand :: RadioBox a -> IO () -> IO ()
radioBoxOnCommand radioBox eventHandler
  = windowOnEvent radioBox [wxEVT_COMMAND_RADIOBOX_SELECTED] eventHandler (\evt -> eventHandler)

-- | Get the current radio box command handler.
radioBoxGetOnCommand :: RadioBox a -> IO (IO ())
radioBoxGetOnCommand radioBox
  = unsafeWindowGetHandlerState radioBox wxEVT_COMMAND_RADIOBOX_SELECTED skipCurrentEvent


-- | Set an event handler for when a slider item changes.
sliderOnCommand :: Slider a -> IO () -> IO ()
sliderOnCommand slider eventHandler
  = windowOnEvent slider [wxEVT_COMMAND_SLIDER_UPDATED] eventHandler (\evt -> eventHandler)

-- | Get the current slider command event handler.
sliderGetOnCommand :: Slider a -> IO (IO ())
sliderGetOnCommand slider
  = unsafeWindowGetHandlerState slider wxEVT_COMMAND_SLIDER_UPDATED skipCurrentEvent



-- | Set an event handler for when a checkbox clicked.
checkBoxOnCommand :: CheckBox a -> (IO ()) -> IO ()
checkBoxOnCommand checkBox eventHandler
  = windowOnEvent checkBox [wxEVT_COMMAND_CHECKBOX_CLICKED] eventHandler (\evt -> eventHandler)

-- | Get the current check box event handler.
checkBoxGetOnCommand :: CheckBox a -> IO (IO ())
checkBoxGetOnCommand checkBox
  = unsafeWindowGetHandlerState checkBox wxEVT_COMMAND_CHECKBOX_CLICKED (skipCurrentEvent)


{-----------------------------------------------------------------------------------------
  Scrolling
-----------------------------------------------------------------------------------------}
-- | Scroll events.
data EventScroll = ScrollTop      !Orientation !Int    -- ^ scroll to top
                 | ScrollBottom   !Orientation !Int    -- ^ scroll to bottom
                 | ScrollLineUp   !Orientation !Int    -- ^ scroll line up
                 | ScrollLineDown !Orientation !Int    -- ^ scroll line down
                 | ScrollPageUp   !Orientation !Int    -- ^ scroll page up
                 | ScrollPageDown !Orientation !Int    -- ^ scroll page down
                 | ScrollTrack    !Orientation !Int    -- ^ frequent event when user drags the thumbtrack
                 | ScrollRelease  !Orientation !Int    -- ^ thumbtrack is released
                 deriving Show

-- | The orientation of a widget.
data Orientation  = Horizontal | Vertical
                  deriving (Eq, Show)


-- | Get the orientation of a scroll event.
scrollOrientation :: EventScroll -> Orientation
scrollOrientation scroll
  = case scroll of
      ScrollTop      orient pos   -> orient
      ScrollBottom   orient pos   -> orient
      ScrollLineUp   orient pos   -> orient
      ScrollLineDown orient pos   -> orient
      ScrollPageUp   orient pos   -> orient
      ScrollPageDown orient pos   -> orient
      ScrollTrack    orient pos   -> orient
      ScrollRelease  orient pos   -> orient

-- | Get the position of the scroll bar.
scrollPos :: EventScroll -> Int
scrollPos scroll
  = case scroll of
      ScrollTop      orient pos   -> pos
      ScrollBottom   orient pos   -> pos
      ScrollLineUp   orient pos   -> pos
      ScrollLineDown orient pos   -> pos
      ScrollPageUp   orient pos   -> pos
      ScrollPageDown orient pos   -> pos
      ScrollTrack    orient pos   -> pos
      ScrollRelease  orient pos   -> pos



fromScrollEvent :: ScrollWinEvent a -> IO EventScroll
fromScrollEvent event
  = do orient <- scrollWinEventGetOrientation event
       pos    <- scrollWinEventGetPosition event
       tp     <- eventGetEventType event
       let orientation | orient == wxHORIZONTAL  = Horizontal
                       | otherwise               = Vertical
       case lookup tp scrollEvents of
         Just evt  -> return (evt orientation pos)
         Nothing   -> return (ScrollRelease orientation pos)

scrollEvents :: [(Int,Orientation -> Int -> EventScroll)]
scrollEvents
  = [(wxEVT_SCROLLWIN_TOP,        ScrollTop)
    ,(wxEVT_SCROLLWIN_BOTTOM,     ScrollBottom)
    ,(wxEVT_SCROLLWIN_LINEUP,     ScrollLineUp)
    ,(wxEVT_SCROLLWIN_LINEDOWN,   ScrollLineDown)
    ,(wxEVT_SCROLLWIN_PAGEUP,     ScrollPageUp)
    ,(wxEVT_SCROLLWIN_PAGEDOWN,   ScrollPageDown)
    ,(wxEVT_SCROLLWIN_THUMBTRACK, ScrollTrack)
    ,(wxEVT_SCROLLWIN_THUMBRELEASE, ScrollRelease)
    ]

-- | Set a scroll event handler.
windowOnScroll :: Window a -> (EventScroll -> IO ()) -> IO ()
windowOnScroll window eventHandler
  = windowOnEvent window (map fst scrollEvents) eventHandler scrollHandler
  where
    scrollHandler event
      = do eventScroll <- fromScrollEvent (objectCast event)
           eventHandler eventScroll

-- | Get the current mouse event handler of a window.
windowGetOnScroll :: Window a -> IO (EventScroll -> IO ())
windowGetOnScroll window
  = unsafeWindowGetHandlerState window wxEVT_SCROLLWIN_TOP (\scroll -> skipCurrentEvent)


{-----------------------------------------------------------------------------------------
  Close, Destroy, Create
-----------------------------------------------------------------------------------------}
-- | Set an event handler that is called when the user tries to close a frame or dialog.
-- Don't forget to call the previous handler or 'frameDestroy' explicitly or otherwise the
-- frame won't be closed.
windowOnClose :: Window a -> IO () -> IO ()
windowOnClose window eventHandler
  = windowOnEvent window [wxEVT_CLOSE_WINDOW] eventHandler (\ev -> eventHandler)

-- | Get the current close event handler.
windowGetOnClose :: Window a -> IO (IO ())
windowGetOnClose window
  = unsafeWindowGetHandlerState window wxEVT_CLOSE_WINDOW (do windowDestroy window; return ())

-- | Set an event handler that is called when the window is destroyed.
-- /Note: does not seem to work on windows/.
windowOnDestroy :: Window a -> IO () -> IO ()
windowOnDestroy window eventHandler
  = windowOnEvent window [wxEVT_DESTROY] eventHandler (\ev -> eventHandler)

-- | Get the current destroy event handler.
windowGetOnDestroy :: Window a -> IO (IO ())
windowGetOnDestroy window
  = unsafeWindowGetHandlerState window wxEVT_DESTROY (return ())

-- | Add a delete-event handler to the current installed delete-event handlers.
--
-- > windowAddOnDelete new window
-- >   = do prev <- windowGetOnDelete window
-- >        windowOnDelete window (do{ new; prev })

windowAddOnDelete :: Window a -> IO () -> IO ()
windowAddOnDelete window new
  = do prev <- windowGetOnDelete window
       windowOnDelete window (do{ new; prev })

-- | Set an event handler that is called when the window is deleted.
-- Use with care as the window itself is in a deletion state.
windowOnDelete :: Window a -> IO () -> IO ()
windowOnDelete window eventHandler
  = windowOnEventEx window [wxEVT_DELETE] eventHandler onDelete (\ev -> return ())
  where
    onDelete ownerDeleted
      | ownerDeleted  = eventHandler
      | otherwise     = return ()    -- don't run on disconnect!

-- | Get the current delete event handler.
windowGetOnDelete :: Window a -> IO (IO ())
windowGetOnDelete window
  = unsafeWindowGetHandlerState window wxEVT_DELETE (return ())


-- | Set an event handler that is called when the window is created.
windowOnCreate :: Window a -> IO () -> IO ()
windowOnCreate window eventHandler
  = windowOnEvent window [wxEVT_CREATE] eventHandler (\ev -> eventHandler)

-- | Get the current create event handler.
windowGetOnCreate :: Window a -> IO (IO ())
windowGetOnCreate window
  = unsafeWindowGetHandlerState window wxEVT_CREATE (return ())

-- | Set an event handler that is called when the window is resized.
windowOnSize :: Window a -> IO () -> IO ()
windowOnSize window eventHandler
  = windowOnEvent window [wxEVT_SIZE] eventHandler (\ev -> eventHandler)

-- | Get the current resize event handler.
windowGetOnSize :: Window a -> IO (IO ())
windowGetOnSize window
  = unsafeWindowGetHandlerState window wxEVT_SIZE (return ())

-- | Set an event handler that is called when the window is activated or deactivated.
-- The event parameter is 'True' when the window is activated.
windowOnActivate :: Window a -> (Bool -> IO ()) -> IO ()
windowOnActivate window eventHandler
  = windowOnEvent window [wxEVT_ACTIVATE] eventHandler activateHandler
  where
    activateHandler event
      = do active <- activateEventGetActive (objectCast event)
           eventHandler (boolFromInt active)

-- | Get the current activate event handler.
windowGetOnActivate :: Window a -> IO (Bool -> IO ())
windowGetOnActivate window
  = unsafeWindowGetHandlerState window wxEVT_ACTIVATE (\active -> return ())

-- | Set an event handler that is called when the window gets or loses the focus.
-- The event parameter is 'True' when the window gets the focus.
windowOnFocus :: Window a -> (Bool -> IO ()) -> IO ()
windowOnFocus window eventHandler
  = do windowOnEvent window [wxEVT_SET_FOCUS] eventHandler getFocusHandler
       windowOnEvent window [wxEVT_KILL_FOCUS] eventHandler killFocusHandler
  where
    getFocusHandler event
      = eventHandler True
    killFocusHandler event
      = eventHandler False

-- | Get the current focus event handler.
windowGetOnFocus :: Window a -> IO (Bool -> IO ())
windowGetOnFocus window
  = unsafeWindowGetHandlerState window wxEVT_SET_FOCUS (\getfocus -> return ())


-- | A context menu event is generated when the user righ-clicks in a window
-- or presses shift-F10.
windowOnContextMenu :: Window a -> IO () -> IO ()
windowOnContextMenu window eventHandler
  = windowOnEvent window [wxEVT_CONTEXT_MENU] eventHandler (\ev -> eventHandler)

-- | Get the current context menu event handler.
windowGetOnContextMenu :: Window a -> IO (IO ())
windowGetOnContextMenu window
  = unsafeWindowGetHandlerState window wxEVT_CONTEXT_MENU skipCurrentEvent


-- | A menu event is generated when the user selects a menu item.
-- You should install this handler on the window that owns the menubar or a popup menu.
evtHandlerOnMenuCommand :: EvtHandler a -> Id -> IO () -> IO ()
evtHandlerOnMenuCommand window id eventHandler
  = evtHandlerOnEvent window id id [wxEVT_COMMAND_MENU_SELECTED] eventHandler (\_ -> return ()) (\ev -> eventHandler)

-- | Get the current event handler for a certain menu.
evtHandlerGetOnMenuCommand :: EvtHandler a -> Id -> IO (IO ())
evtHandlerGetOnMenuCommand window id
  = unsafeGetHandlerState window id wxEVT_COMMAND_MENU_SELECTED skipCurrentEvent


-- | An idle vent is generated in idle time. The handler should return whether more
-- idle processing is needed ('True') or otherwise the event loop goes into a passive
-- waiting state.
windowOnIdle :: Window a -> IO Bool -> IO ()
windowOnIdle window eventHandler
  = windowOnEvent window [wxEVT_IDLE] eventHandler idleHandler
  where
    idleHandler event
      = do requestMore <- eventHandler
           idleEventRequestMore (objectCast event) requestMore
           return ()

-- | Get the current context menu event handler.
windowGetOnIdle :: Window a -> IO (IO Bool)
windowGetOnIdle window
  = unsafeWindowGetHandlerState window wxEVT_IDLE (return False)


-- | A timer event is generated by an attached timer, see 'windowTimerAttach'.
-- /Broken!/ (use 'timerOnCommand' instead).
windowOnTimer :: Window a -> IO () -> IO ()
windowOnTimer window eventHandler
  = windowOnEvent window [wxEVT_TIMER] eventHandler (\ev -> eventHandler)

-- | Get the current timer handler.
windowGetOnTimer :: Window a -> IO (IO ())
windowGetOnTimer window
  = unsafeWindowGetHandlerState window wxEVT_TIMER (return ())

{-----------------------------------------------------------------------------------------
  Paint
-----------------------------------------------------------------------------------------}
-- | Set an event handler that is called when the window needs repainting.
-- When the first argument is 'True', double-buffering is used to reduce flickering.
-- The event handler gets a special 'PaintDC' drawing context, the current
-- logical view rectangle and the region that needs repainting. The coordinates
-- are already adjusted for scrolled windows and The 'PaintDC' is already clipped
-- to the update region. If you need to draw outside the this area, use a 'ClientDC'.
windowOnPaint :: Window a -> Bool -> (DC () -> Rect -> [Rect] -> IO ()) -> IO ()
windowOnPaint window noflicker eventHandler
  = do cache <- if noflicker
                 then do v <- varCreate objectNull
                         return (Just v)
                 else return Nothing
       windowOnEventEx window [wxEVT_PAINT] eventHandler (destroy cache) (onPaint cache eventHandler)
  where
    destroy cache ownerDeleted
      = case cache of
          Nothing -> return ()
          Just v  -> do bitmap <- varSwap v objectNull
                        when (bitmap/=objectNull) (bitmapDelete bitmap)

-- | Get the current paint event handler.
windowGetOnPaint :: Window a -> IO (DC () -> Rect -> [Rect] -> IO ())
windowGetOnPaint window
  = unsafeWindowGetHandlerState window wxEVT_PAINT (\dc rect region -> return ())


-- onPaint :: Maybe (Var (Bitmap ()) -> (DC () -> Rect -> [Rect] -> IO ()) -> (Event () -> IO ())

onPaint cache handler event
  = do obj <- eventGetEventObject event
       if (obj==objectNull)
        then return ()
        else do let window = objectCast obj
                region <- windowGetUpdateRects window
                view   <- windowGetViewRect window
                withPaintDC window (\paintDC ->
                  do isScrolled <- objectIsScrolledWindow window
                     when (isScrolled) (scrolledWindowPrepareDC (objectCast window) paintDC)
                     case cache of
                      Just _  -> dcBufferWithRef paintDC cache view (\dc -> handler dc view region)
                      Nothing -> handler (objectCast paintDC) view region)
                return ()

windowGetUpdateRects :: Window a -> IO [Rect]
windowGetUpdateRects window
  = do region <- windowGetUpdateRegion window
       iter   <- regionIteratorCreateFromRegion region
       rects  <- getRects iter
       regionIteratorDelete iter
       p <- windowGetViewStart window
       return (map (rectMove (vecFromPoint p)) rects)
  where
    getRects iter
      = do more <- regionIteratorHaveRects iter
           if (boolFromInt more)
            then do x <- regionIteratorGetX iter
                    y <- regionIteratorGetY iter
                    w <- regionIteratorGetWidth iter
                    h <- regionIteratorGetHeight iter
                    regionIteratorNext iter
                    rs <- getRects iter
                    return (rect (pt x y) (sz w h) : rs)
            else return []


{-----------------------------------------------------------------------------------------
  Modifiers
-----------------------------------------------------------------------------------------}
-- | Called when a process is ended with the process @pid@ and exitcode.
evtHandlerOnEndProcess :: EvtHandler a -> (Int -> Int -> IO ()) -> IO ()
evtHandlerOnEndProcess  evtHandler handler
  = evtHandlerOnEvent evtHandler (-1) (-1) [wxEVT_END_PROCESS] handler onDelete onEndProcess
  where
    onDelete ownerDeleted
      = return ()

    onEndProcess event
      = let processEvent = objectCast event
        in  do pid  <- processEventGetPid processEvent
               code <- processEventGetExitCode processEvent
               handler pid code


-- | Retrieve the current end process handler.
evtHandlerGetOnEndProcess :: EvtHandler a -> IO (Int -> Int -> IO ())
evtHandlerGetOnEndProcess evtHandler
  = unsafeGetHandlerState evtHandler (-1) wxEVT_END_PROCESS (\pid code -> return ())


-- | The status of a stream (see 'StreamBase')
data StreamStatus = StreamOk          -- ^ No error.
                  | StreamEof         -- ^ No more input.
                  | StreamReadError   -- ^ Read error.
                  | StreamWriteError  -- ^ Write error.
                  deriving (Eq,Show)

-- | Convert a stream status code into 'StreamStatus'.
streamStatusFromInt :: Int -> StreamStatus
streamStatusFromInt code
  | code == wxSTREAM_NO_ERROR     = StreamOk
  | code == wxSTREAM_EOF          = StreamEof
  | code == wxSTREAM_READ_ERROR   = StreamReadError
  | code == wxSTREAM_WRITE_ERROR  = StreamWriteError
  | otherwise                     = StreamReadError


-- | Install an event handler on an input stream. The handler is called
-- whenever input is read (or when an error occurred). The third parameter
-- gives the size of the input batches. The orignal input stream should no longer be referenced after this call!
evtHandlerOnInput :: EvtHandler b -> (String -> StreamStatus -> IO ()) -> InputStream a -> Int -> IO ()
evtHandlerOnInput evtHandler handler stream bufferLen
  = do sink <- inputSinkCreate stream evtHandler bufferLen
       evtHandlerOnInputSink evtHandler handler sink
       inputSinkStart sink

-- | Install an event handler on a specific input sink. It is advised to
-- use the 'evtHandlerOnInput' whenever retrieval of the handler is not necessary.
evtHandlerOnInputSink :: EvtHandler b -> (String -> StreamStatus -> IO ()) -> InputSink a -> IO ()
evtHandlerOnInputSink evtHandler handler sink
  = do id <- inputSinkGetId sink
       evtHandlerOnEvent evtHandler id id [wxEVT_INPUT_SINK] handler onDelete onInput
  where
    onDelete ownerDeleted
      = return ()

    onInput event
      = let inputSinkEvent = objectCast event
        in  do input <- inputSinkEventLastString inputSinkEvent
               code  <- inputSinkEventLastError inputSinkEvent
               handler input (streamStatusFromInt code)


-- | Retrieve the current input stream handler.
evtHandlerGetOnInputSink :: EvtHandler b -> IO (String -> StreamStatus -> IO ())
evtHandlerGetOnInputSink evtHandler
  = unsafeGetHandlerState evtHandler (-1) wxEVT_INPUT_SINK (\input status -> return ())

-- | Read the input from an 'InputSinkEvent'.
inputSinkEventLastString :: InputSinkEvent a -> IO String
inputSinkEventLastString inputSinkEvent
  = do n <- inputSinkEventLastRead inputSinkEvent
       if (n <= 0)
        then return ""
        else do buffer <- inputSinkEventLastInput inputSinkEvent
                peekCStringLen (buffer,n)


{-----------------------------------------------------------------------------------------
  Modifiers
-----------------------------------------------------------------------------------------}
-- | The @Modifiers@ indicate the meta keys that have been pressed ('True') or not ('False').
data Modifiers  = Modifiers
                  { altDown     :: !Bool   -- ^ alt key down
                  , shiftDown   :: !Bool   -- ^ shift key down
                  , controlDown :: !Bool   -- ^ control key down
                  , metaDown    :: !Bool   -- ^ meta key down
                  }
                  deriving (Eq)

instance Show Modifiers where
  show mods = showModifiers mods

-- | Show modifiers, for example for use in menus.
showModifiers :: Modifiers -> String
showModifiers mods
  = concat $ intersperse "+" $ filter (not.null)
    [if controlDown mods then "Ctrl" else ""
    ,if altDown mods     then "Alt" else ""
    ,if shiftDown mods   then "Shift" else ""
    ,if metaDown mods    then "Meta" else ""
    ]


-- | Construct a 'Modifiers' structure with no meta keys pressed.
noneDown :: Modifiers
noneDown = Modifiers False False False False

-- | Construct a 'Modifiers' structure with just Shift meta key pressed.
justShift   :: Modifiers
justShift   = noneDown{ shiftDown = True }

-- | Construct a 'Modifiers' structure with just Alt meta key pressed.
justAlt     :: Modifiers
justAlt     = noneDown{ altDown = True }

-- | Construct a 'Modifiers' structure with just Ctrl meta key pressed.
justControl :: Modifiers
justControl = noneDown{ controlDown = True }

-- | Construct a 'Modifiers' structure with just Meta meta key pressed.
justMeta :: Modifiers
justMeta = noneDown{ metaDown = True }

-- | Test if no meta key was pressed.
isNoneDown :: Modifiers -> Bool
isNoneDown (Modifiers shift control alt meta) = not (shift || control || alt || meta)

-- | Tranform modifiers into an accelerator modifiers code.
modifiersToAccelFlags :: Modifiers -> Int
modifiersToAccelFlags mod
  = mask (altDown mod) 0x01 + mask (controlDown mod) 0x02 + mask (shiftDown mod) 0x04
  where
    mask test flag = if test then flag else 0

{-----------------------------------------------------------------------------------------
  MouseEvent
-----------------------------------------------------------------------------------------}
-- | Mouse events. The position the logical (unscrolled) position.
data EventMouse
  =  MouseMotion      !Point !Modifiers -- ^ Mouse was moved over the client area of the window
  |  MouseEnter       !Point !Modifiers -- ^ Mouse enters in the client area of the window
  |  MouseLeave       !Point !Modifiers -- ^ Mouse leaves the client area of the window
  |  MouseLeftDown    !Point !Modifiers -- ^ Mouse left button goes down
  |  MouseLeftUp      !Point !Modifiers -- ^ Mouse left  button goes up
  |  MouseLeftDClick  !Point !Modifiers -- ^ Mouse left button double click
  |  MouseLeftDrag    !Point !Modifiers -- ^ Mouse left button drag
  |  MouseRightDown   !Point !Modifiers -- ^ Mouse right button goes down
  |  MouseRightUp     !Point !Modifiers -- ^ Mouse right  button goes up
  |  MouseRightDClick !Point !Modifiers -- ^ Mouse right button double click
  |  MouseRightDrag   !Point !Modifiers -- ^ Mouse right button drag (unsupported on most platforms)
  |  MouseMiddleDown  !Point !Modifiers -- ^ Mouse middle button goes down
  |  MouseMiddleUp    !Point !Modifiers -- ^ Mouse middle  button goes up
  |  MouseMiddleDClick !Point !Modifiers -- ^ Mouse middle button double click
  |  MouseMiddleDrag  !Point !Modifiers -- ^ Mouse middle button drag (unsupported on most platforms)
  |  MouseWheel !Bool !Point !Modifiers -- ^ Mouse wheel rotation. (Bool is True for a downward rotation)
  deriving (Eq) -- ,Show)


instance Show EventMouse where
  show mouse  = showMouse mouse

-- | Show an 'EventMouse' in a user friendly way.
showMouse :: EventMouse -> String
showMouse mouse
  = (if (null modsText) then "" else modsText ++ "+") ++ action ++ " at " ++ show (x,y)
  where
    modsText     = show (mouseModifiers mouse)
    (Point x y)  = mousePos mouse
    action
      = case mouse of
          MouseMotion p m       -> "Motion"
          MouseEnter p m        -> "Enter"
          MouseLeave p m        -> "Leave"
          MouseLeftDown p m     -> "Left down"
          MouseLeftUp p m       -> "Left up"
          MouseLeftDClick p m   -> "Left double click"
          MouseLeftDrag p m     -> "Left drag"
          MouseRightDown p m    -> "Right down"
          MouseRightUp p m      -> "Right up"
          MouseRightDClick p m  -> "Right double click"
          MouseRightDrag p m    -> "Right drag"
          MouseMiddleDown p m   -> "Middle down"
          MouseMiddleUp p m     -> "Middle up"
          MouseMiddleDClick p m -> "Middle double click"
          MouseMiddleDrag p m   -> "Middle drag"
          MouseWheel down p m   -> "Wheel " ++ (if down then "down" else "up")


-- | Extract the position from a 'MouseEvent'.
mousePos :: EventMouse -> Point
mousePos mouseEvent
  = case mouseEvent of
      MouseMotion p m        -> p
      MouseEnter p m        -> p
      MouseLeave p m        -> p
      MouseLeftDown p m     -> p
      MouseLeftUp p m       -> p
      MouseLeftDClick p m   -> p
      MouseLeftDrag p m     -> p
      MouseRightDown p m    -> p
      MouseRightUp p m      -> p
      MouseRightDClick p m  -> p
      MouseRightDrag p m    -> p
      MouseMiddleDown p m   -> p
      MouseMiddleUp p m     -> p
      MouseMiddleDClick p m -> p
      MouseMiddleDrag p m   -> p
      MouseWheel _ p m      -> p

-- | Extract the modifiers from a 'MouseEvent'.
mouseModifiers :: EventMouse -> Modifiers
mouseModifiers mouseEvent
  = case mouseEvent of
      MouseMotion p m       -> m
      MouseEnter p m        -> m
      MouseLeave p m        -> m
      MouseLeftDown p m     -> m
      MouseLeftUp p m       -> m
      MouseLeftDClick p m   -> m
      MouseLeftDrag p m     -> m
      MouseRightDown p m    -> m
      MouseRightUp p m      -> m
      MouseRightDClick p m  -> m
      MouseRightDrag p m    -> m
      MouseMiddleDown p m   -> m
      MouseMiddleUp p m     -> m
      MouseMiddleDClick p m -> m
      MouseMiddleDrag p m   -> m
      MouseWheel _ p m      -> m

fromMouseEvent :: MouseEvent a -> IO EventMouse
fromMouseEvent event
  = do x <- mouseEventGetX event
       y <- mouseEventGetY event
       obj   <- eventGetEventObject event
       point <- windowCalcUnscrolledPosition (objectCast obj) (Point x y)

       altDown     <- mouseEventAltDown event
       controlDown <- mouseEventControlDown event
       shiftDown   <- mouseEventShiftDown event
       metaDown    <- mouseEventMetaDown event
       let modifiers = Modifiers altDown shiftDown controlDown metaDown

       dragging    <- mouseEventDragging event
       if (dragging)
        then do but <- mouseEventGetButton event
                case but of
                  3 -> return (MouseRightDrag point modifiers)
                  2 -> return (MouseMiddleDrag point modifiers)
                  _ -> return (MouseLeftDrag point modifiers)
        else do tp <- eventGetEventType event
                case lookup tp mouseEventTypes of
                  Just mouse  -> return (mouse point modifiers)
                  Nothing     -> if (tp==wxEVT_MOUSEWHEEL)
                                  then do rot   <- mouseEventGetWheelRotation event
                                          delta <- mouseEventGetWheelDelta event
                                          if (abs rot >= delta)
                                           then return (MouseWheel (rot<0) point modifiers)
                                           else return (MouseMotion point modifiers)
                                  else return (MouseMotion point modifiers)

mouseEventTypes :: [(Int,Point -> Modifiers -> EventMouse)]
mouseEventTypes
  = [(wxEVT_MOTION       , MouseMotion)         -- must be the first element, see "windowOnMouse"
    ,(wxEVT_ENTER_WINDOW , MouseEnter)
    ,(wxEVT_LEAVE_WINDOW , MouseLeave)
    ,(wxEVT_LEFT_DOWN    , MouseLeftDown)
    ,(wxEVT_LEFT_UP      , MouseLeftUp)
    ,(wxEVT_LEFT_DCLICK  , MouseLeftDClick)
    ,(wxEVT_MIDDLE_DOWN  , MouseMiddleDown)
    ,(wxEVT_MIDDLE_UP    , MouseMiddleUp)
    ,(wxEVT_MIDDLE_DCLICK, MouseMiddleDClick)
    ,(wxEVT_RIGHT_DOWN   , MouseRightDown)
    ,(wxEVT_RIGHT_UP     , MouseRightUp)
    ,(wxEVT_RIGHT_DCLICK , MouseRightDClick)
    ]

-- | Set a mouse event handler for a window. The first argument determines whether
-- mouse motion events ('MouseMotion') are handled or not.
windowOnMouse :: Window a -> Bool -> (EventMouse -> IO ()) -> IO ()
windowOnMouse window allowMotion handler
  = windowOnEvent window mouseEvents handler eventHandler
  where
    mouseEvents
      = (map fst (if allowMotion then mouseEventTypes else tail (mouseEventTypes))) ++ [wxEVT_MOUSEWHEEL]

    eventHandler event
      = do eventMouse <- fromMouseEvent (objectCast event)
           handler eventMouse

-- | Get the current mouse event handler of a window.
windowGetOnMouse :: Window a -> IO (EventMouse -> IO ())
windowGetOnMouse window
  = unsafeWindowGetHandlerState window wxEVT_ENTER_WINDOW (\ev -> skipCurrentEvent)


{-----------------------------------------------------------------------------------------
  KeyboardEvent
-----------------------------------------------------------------------------------------}
-- | Set an event handler for untranslated key presses. If 'skipCurrentEvent' is not
-- called, the corresponding 'windowOnKeyChar' eventhandler won't be called.
windowOnKeyDown :: Window a -> (EventKey -> IO ()) -> IO ()
windowOnKeyDown window handler
  = windowOnEvent window [wxEVT_KEY_DOWN] handler eventHandler
  where
    eventHandler event
      = do eventKey <- eventKeyFromEvent (objectCast event)
           handler eventKey

-- | Get the current key down handler of a window.
windowGetOnKeyDown :: Window a -> IO (EventKey -> IO ())
windowGetOnKeyDown window
  = unsafeWindowGetHandlerState window wxEVT_KEY_DOWN (\eventKey -> skipCurrentEvent)


-- | Set an event handler for translated key presses.
windowOnKeyChar :: Window a -> (EventKey -> IO ()) -> IO ()
windowOnKeyChar window handler
  = windowOnEvent window [wxEVT_CHAR] handler eventHandler
  where
    eventHandler event
      = do eventKey <- eventKeyFromEvent (objectCast event)
           handler eventKey

-- | Get the current translated key handler of a window.
windowGetOnKeyChar :: Window a -> IO (EventKey -> IO ())
windowGetOnKeyChar window
  = unsafeWindowGetHandlerState window wxEVT_CHAR (\eventKey -> skipCurrentEvent)


-- | Set an event handler for (untranslated) key releases.
windowOnKeyUp :: Window a -> (EventKey -> IO ()) -> IO ()
windowOnKeyUp window handler
  = windowOnEvent window [wxEVT_KEY_UP] handler eventHandler
  where
    eventHandler event
      = do eventKey <- eventKeyFromEvent (objectCast event)
           handler eventKey

-- | Get the current key release handler of a window.
windowGetOnKeyUp :: Window a -> IO (EventKey -> IO ())
windowGetOnKeyUp window
  = unsafeWindowGetHandlerState window wxEVT_KEY_UP (\keyInfo -> skipCurrentEvent)


eventKeyFromEvent :: KeyEvent a -> IO EventKey
eventKeyFromEvent event
  = do x <- keyEventGetX event
       y <- keyEventGetY event
       obj   <- eventGetEventObject event
       point <- windowCalcUnscrolledPosition (objectCast obj) (Point x y)

       altDown     <- keyEventAltDown event
       controlDown <- keyEventControlDown event
       shiftDown   <- keyEventShiftDown event
       metaDown    <- keyEventMetaDown event
       let modifiers = Modifiers altDown shiftDown controlDown metaDown

       keyCode <- keyEventGetKeyCode event
       let key = keyCodeToKey keyCode

       return (EventKey key modifiers point)



-- | A keyboard event contains the key, the modifiers and the focus point.
data EventKey  = EventKey !Key !Modifiers !Point
               deriving (Eq,Show)

-- | Extract the key from a keyboard event.
keyKey :: EventKey -> Key
keyKey (EventKey key mods pos) = key

-- | Extract the modifiers from a keyboard event.
keyModifiers :: EventKey -> Modifiers
keyModifiers (EventKey key mods pos) = mods

-- | Extract the position from a keyboard event.
keyPos :: EventKey -> Point
keyPos (EventKey key mods pos) = pos


-- | A low-level virtual key code.
type KeyCode  = Int

-- | A 'Key' represents a single key on a keyboard.
data Key
  = KeyChar  !Char        -- ^ An ascii code.
  | KeyOther !KeyCode     -- ^ An unknown virtual key.
  | KeyBack
  | KeyTab
  | KeyReturn
  | KeyEscape
  | KeySpace
  | KeyDelete
  | KeyInsert
  | KeyPrior              -- ^ Page up.
  | KeyNext               -- ^ Page down.
  | KeyEnd
  | KeyHome
  | KeyLeft
  | KeyUp
  | KeyRight
  | KeyDown
  | KeyPageUp
  | KeyPageDown
  | KeyStart
  | KeyClear
  | KeyShift
  | KeyAlt
  | KeyControl
  | KeyMenu
  | KeyPause
  | KeyCapital
  | KeyHelp
  | KeySelect
  | KeyPrint
  | KeyExecute
  | KeySnapshot
  | KeyCancel
  | KeyLeftButton
  | KeyRightButton
  | KeyMiddleButton
  | KeyNum0
  | KeyNum1
  | KeyNum2
  | KeyNum3
  | KeyNum4
  | KeyNum5
  | KeyNum6
  | KeyNum7
  | KeyNum8
  | KeyNum9
  | KeyMultiply
  | KeyAdd
  | KeySeparator
  | KeySubtract
  | KeyDecimal
  | KeyDivide
  | KeyF1
  | KeyF2
  | KeyF3
  | KeyF4
  | KeyF5
  | KeyF6
  | KeyF7
  | KeyF8
  | KeyF9
  | KeyF10
  | KeyF11
  | KeyF12
  | KeyF13
  | KeyF14
  | KeyF15
  | KeyF16
  | KeyF17
  | KeyF18
  | KeyF19
  | KeyF20
  | KeyF21
  | KeyF22
  | KeyF23
  | KeyF24
  | KeyNumLock
  | KeyScroll
{- Note: If we add "deriving (Show)" we get a strange link error in ghci:
    Loading package wxh ... linking ... Overflown relocs: 122
-}
  deriving (Eq)

{-
  | KeyNumSpace
  | KeyNumTab
  | KeyNumEnter
  | KeyNumF1
  | KeyNumF2
  | KeyNumF3
  | KeyNumF4
  | KeyNumHome
  | KeyNumLeft
  | KeyNumUp
  | KeyNumRight
  | KeyNumDown
  | KeyNumPrior
  | KeyNumPageUp
  | KeyNumNext
  | KeyNumPageDown
  | KeyNumEnd
  | KeyNumBegin
  | KeyNumInsert
  | KeyNumDelete
  | KeyNumEqual
  | KeyNumMultiply
  | KeyNumAdd
  | KeyNumSeparator
  | KeyNumSubstract
  | KeyNumDecimal
  | KeyNumSubstract
-}

-- | From a key to a virtual key code.
keyToKeyCode :: Key -> KeyCode
keyToKeyCode key
  = case key of
      KeyChar c       -> fromEnum c
      KeyOther code   -> code
      KeyBack         -> wxK_BACK
      KeyTab          -> wxK_TAB
      KeyReturn       -> wxK_RETURN
      KeyEscape       -> wxK_ESCAPE
      KeySpace        -> wxK_SPACE
      KeyDelete       -> wxK_DELETE
      KeyInsert       -> wxK_INSERT
      KeyPrior        -> wxK_PRIOR
      KeyNext         -> wxK_NEXT
      KeyEnd          -> wxK_END
      KeyHome         -> wxK_HOME
      KeyLeft         -> wxK_LEFT
      KeyUp           -> wxK_UP
      KeyRight        -> wxK_RIGHT
      KeyDown         -> wxK_DOWN
      KeyPageUp       -> wxK_PAGEUP
      KeyPageDown     -> wxK_PAGEDOWN
      KeyStart        -> wxK_START
      KeyClear        -> wxK_CLEAR
      KeyShift        -> wxK_SHIFT
      KeyAlt          -> wxK_ALT
      KeyControl      -> wxK_CONTROL
      KeyMenu         -> wxK_MENU
      KeyPause        -> wxK_PAUSE
      KeyCapital      -> wxK_CAPITAL
      KeyHelp         -> wxK_HELP
      KeySelect       -> wxK_SELECT
      KeyPrint        -> wxK_PRINT
      KeyExecute      -> wxK_EXECUTE
      KeySnapshot     -> wxK_SNAPSHOT
      KeyCancel       -> wxK_CANCEL
      KeyLeftButton   -> wxK_LBUTTON
      KeyRightButton  -> wxK_RBUTTON
      KeyMiddleButton -> wxK_MBUTTON
      KeyNum0         -> wxK_NUMPAD0
      KeyNum1         -> wxK_NUMPAD1
      KeyNum2         -> wxK_NUMPAD2
      KeyNum3         -> wxK_NUMPAD3
      KeyNum4         -> wxK_NUMPAD4
      KeyNum5         -> wxK_NUMPAD5
      KeyNum6         -> wxK_NUMPAD6
      KeyNum7         -> wxK_NUMPAD7
      KeyNum8         -> wxK_NUMPAD8
      KeyNum9         -> wxK_NUMPAD9
      KeyMultiply     -> wxK_MULTIPLY
      KeyAdd          -> wxK_ADD
      KeySeparator    -> wxK_SEPARATOR
      KeySubtract     -> wxK_SUBTRACT
      KeyDecimal      -> wxK_DECIMAL
      KeyDivide       -> wxK_DIVIDE
      KeyF1           -> wxK_F1
      KeyF2           -> wxK_F2
      KeyF3           -> wxK_F3
      KeyF4           -> wxK_F4
      KeyF5           -> wxK_F5
      KeyF6           -> wxK_F6
      KeyF7           -> wxK_F7
      KeyF8           -> wxK_F8
      KeyF9           -> wxK_F9
      KeyF10          -> wxK_F10
      KeyF11          -> wxK_F11
      KeyF12          -> wxK_F12
      KeyF13          -> wxK_F13
      KeyF14          -> wxK_F14
      KeyF15          -> wxK_F15
      KeyF16          -> wxK_F16
      KeyF17          -> wxK_F17
      KeyF18          -> wxK_F18
      KeyF19          -> wxK_F19
      KeyF20          -> wxK_F20
      KeyF21          -> wxK_F21
      KeyF22          -> wxK_F22
      KeyF23          -> wxK_F23
      KeyF24          -> wxK_F24
      KeyNumLock      -> wxK_NUMLOCK
      KeyScroll       -> wxK_SCROLL

-- | A virtual key code to a key.
keyCodeToKey :: KeyCode -> Key
keyCodeToKey keyCode
  = if (keyCode < wxK_DELETE && keyCode > wxK_SPACE)     -- optimize for the common case
     then KeyChar (toEnum keyCode)
     else case IntMap.lookup keyCode keyCodeMap of
            Just key -> key
            Nothing  | keyCode <= 255  -> KeyChar (toEnum keyCode)
                     | otherwise       -> KeyOther keyCode

-- Use a big-endian patricia tree to efficiently map key codes to Haskell keys.
-- Since it is a static map, we could maybe use one of Knuth's optimally balanced
-- trees....
keyCodeMap :: IntMap.IntMap Key
keyCodeMap
  = IntMap.fromList
    [(wxK_BACK         , KeyBack)
    ,(wxK_TAB          , KeyTab)
    ,(wxK_RETURN       , KeyReturn)
    ,(wxK_ESCAPE       , KeyEscape)
    ,(wxK_SPACE        , KeySpace)
    ,(wxK_DELETE       , KeyDelete)
    ,(wxK_INSERT       , KeyInsert)
    ,(wxK_PRIOR        , KeyPrior)
    ,(wxK_NEXT         , KeyNext)
    ,(wxK_END          , KeyEnd)
    ,(wxK_HOME         , KeyHome)
    ,(wxK_LEFT         , KeyLeft)
    ,(wxK_UP           , KeyUp)
    ,(wxK_RIGHT        , KeyRight)
    ,(wxK_DOWN         , KeyDown)
    ,(wxK_PAGEUP       , KeyPageUp)
    ,(wxK_PAGEDOWN     , KeyPageDown)
    ,(wxK_START        , KeyStart)
    ,(wxK_CLEAR        , KeyClear)
    ,(wxK_SHIFT        , KeyShift)
    ,(wxK_ALT          , KeyAlt)
    ,(wxK_CONTROL      , KeyControl)
    ,(wxK_MENU         , KeyMenu)
    ,(wxK_PAUSE        , KeyPause)
    ,(wxK_CAPITAL      , KeyCapital)
    ,(wxK_HELP         , KeyHelp)
    ,(wxK_SELECT       , KeySelect)
    ,(wxK_PRINT        , KeyPrint)
    ,(wxK_EXECUTE      , KeyExecute)
    ,(wxK_SNAPSHOT     , KeySnapshot)
    ,(wxK_CANCEL       , KeyCancel)
    ,(wxK_LBUTTON      , KeyLeftButton)
    ,(wxK_RBUTTON      , KeyRightButton)
    ,(wxK_MBUTTON      , KeyMiddleButton)
    ,(wxK_NUMPAD0      , KeyNum0)
    ,(wxK_NUMPAD1      , KeyNum1)
    ,(wxK_NUMPAD2      , KeyNum2)
    ,(wxK_NUMPAD3      , KeyNum3)
    ,(wxK_NUMPAD4      , KeyNum4)
    ,(wxK_NUMPAD5      , KeyNum5)
    ,(wxK_NUMPAD6      , KeyNum6)
    ,(wxK_NUMPAD7      , KeyNum7)
    ,(wxK_NUMPAD8      , KeyNum8)
    ,(wxK_NUMPAD9      , KeyNum9)
    ,(wxK_MULTIPLY     , KeyMultiply)
    ,(wxK_ADD          , KeyAdd)
    ,(wxK_SEPARATOR    , KeySeparator)
    ,(wxK_SUBTRACT     , KeySubtract)
    ,(wxK_DECIMAL      , KeyDecimal)
    ,(wxK_DIVIDE       , KeyDivide)
    ,(wxK_F1           , KeyF1)
    ,(wxK_F2           , KeyF2)
    ,(wxK_F3           , KeyF3)
    ,(wxK_F4           , KeyF4)
    ,(wxK_F5           , KeyF5)
    ,(wxK_F6           , KeyF6)
    ,(wxK_F7           , KeyF7)
    ,(wxK_F8           , KeyF8)
    ,(wxK_F9           , KeyF9)
    ,(wxK_F10          , KeyF10)
    ,(wxK_F11          , KeyF11)
    ,(wxK_F12          , KeyF12)
    ,(wxK_F13          , KeyF13)
    ,(wxK_F14          , KeyF14)
    ,(wxK_F15          , KeyF15)
    ,(wxK_F16          , KeyF16)
    ,(wxK_F17          , KeyF17)
    ,(wxK_F18          , KeyF18)
    ,(wxK_F19          , KeyF19)
    ,(wxK_F20          , KeyF20)
    ,(wxK_F21          , KeyF21)
    ,(wxK_F22          , KeyF22)
    ,(wxK_F23          , KeyF23)
    ,(wxK_F24          , KeyF24)
    ,(wxK_NUMLOCK      , KeyNumLock)
    ,(wxK_SCROLL       , KeyScroll)
    -- translate with loss of information
    ,(wxK_NUMPAD_SPACE , KeySpace)
    ,(wxK_NUMPAD_TAB   , KeyTab)
    ,(wxK_NUMPAD_ENTER , KeyReturn)
    ,(wxK_NUMPAD_F1    , KeyF1)
    ,(wxK_NUMPAD_F2    , KeyF2)
    ,(wxK_NUMPAD_F3    , KeyF3)
    ,(wxK_NUMPAD_F4    , KeyF4)
    ,(wxK_NUMPAD_HOME  , KeyHome)
    ,(wxK_NUMPAD_LEFT  , KeyLeft)
    ,(wxK_NUMPAD_UP    , KeyUp)
    ,(wxK_NUMPAD_RIGHT , KeyRight)
    ,(wxK_NUMPAD_DOWN  , KeyDown)
    ,(wxK_NUMPAD_PRIOR , KeyPrior)
    ,(wxK_NUMPAD_PAGEUP   , KeyPageUp)
    ,(wxK_NUMPAD_NEXT     , KeyNext)
    ,(wxK_NUMPAD_PAGEDOWN , KeyPageDown)
    ,(wxK_NUMPAD_END      , KeyEnd)
--            ,(wxK_NUMPAD_BEGIN    , KeyBegin)
    ,(wxK_NUMPAD_INSERT   , KeyInsert)
    ,(wxK_NUMPAD_DELETE   , KeyDelete)
--            ,(wxK_NUMPAD_EQUAL    , KeyEqual)
    ,(wxK_NUMPAD_MULTIPLY , KeyMultiply)
    ,(wxK_NUMPAD_ADD      , KeyAdd)
    ,(wxK_NUMPAD_SEPARATOR  , KeySeparator)
    ,(wxK_NUMPAD_SUBTRACT   , KeySubtract)
    ,(wxK_NUMPAD_DECIMAL    , KeyDecimal)
    ,(wxK_NUMPAD_DIVIDE     , KeyDivide)
    ]


instance Show Key where
  show k  = showKey k

-- | Show a key\/modifiers combination, for example for use in menus.
showKeyModifiers :: Key -> Modifiers -> String
showKeyModifiers key mods
  | null modsText = show key
  | otherwise     = modsText ++ "+" ++ show key
  where
    modsText = show mods

-- | Show a key for use in menus for example.
showKey :: Key -> String
showKey key
  = case key of
      KeyChar c       -> [c]
      KeyOther code   -> "[" ++ show code ++ "]"
      KeyBack         -> "Backspace"
      KeyTab          -> "Tab"
      KeyReturn       -> "Enter"
      KeyEscape       -> "Esc"
      KeySpace        -> "Space"
      KeyDelete       -> "Delete"
      KeyInsert       -> "Insert"
      KeyPrior        -> "PgUp"
      KeyNext         -> "PgDn"
      KeyEnd          -> "End"
      KeyHome         -> "Home"
      KeyLeft         -> "Left"
      KeyUp           -> "Up"
      KeyRight        -> "Right"
      KeyDown         -> "Down"
      KeyPageUp       -> "PgUp"
      KeyPageDown     -> "PgDn"
      KeyStart        -> "Start"
      KeyClear        -> "Clear"
      KeyShift        -> "Shift"
      KeyAlt          -> "Alt"
      KeyControl      -> "Ctrl"
      KeyMenu         -> "Menu"
      KeyPause        -> "Pause"
      KeyCapital      -> "Capital"
      KeyHelp         -> "Help"
      KeySelect       -> "Select"
      KeyPrint        -> "Print"
      KeyExecute      -> "Execute"
      KeySnapshot     -> "Snapshot"
      KeyCancel       -> "Cancel"
      KeyLeftButton   -> "Left Button"
      KeyRightButton  -> "Right Button"
      KeyMiddleButton -> "Middle Button"
      KeyNum0         -> "Num 0"
      KeyNum1         -> "Num 1"
      KeyNum2         -> "Num 2"
      KeyNum3         -> "Num 3"
      KeyNum4         -> "Num 4"
      KeyNum5         -> "Num 5"
      KeyNum6         -> "Num 6"
      KeyNum7         -> "Num 7"
      KeyNum8         -> "Num 8"
      KeyNum9         -> "Num 9"
      KeyMultiply     -> "Num *"
      KeyAdd          -> "Num +"
      KeySeparator    -> "Num Separator"
      KeySubtract     -> "Num -"
      KeyDecimal      -> "Num ."
      KeyDivide       -> "Num /"
      KeyF1           -> "F1"
      KeyF2           -> "F2"
      KeyF3           -> "F3"
      KeyF4           -> "F4"
      KeyF5           -> "F5"
      KeyF6           -> "F6"
      KeyF7           -> "F7"
      KeyF8           -> "F8"
      KeyF9           -> "F9"
      KeyF10          -> "F10"
      KeyF11          -> "F11"
      KeyF12          -> "F12"
      KeyF13          -> "F13"
      KeyF14          -> "F14"
      KeyF15          -> "F15"
      KeyF16          -> "F16"
      KeyF17          -> "F17"
      KeyF18          -> "F18"
      KeyF19          -> "F19"
      KeyF20          -> "F20"
      KeyF21          -> "F21"
      KeyF22          -> "F22"
      KeyF23          -> "F23"
      KeyF24          -> "F24"
      KeyNumLock      -> "Numlock"
      KeyScroll       -> "Scroll"


------------------------------------------------------------------------------------------
-- TimerEx is handled specially.
------------------------------------------------------------------------------------------
-- | Create a new 'Timer' that is attached to a window. It is automatically deleted when
-- its owner is deleted (using 'windowAddOnDelete'). The owning window will receive
-- timer events ('windowOnTimer'). /Broken!/ (use 'windowTimerCreate'\/'timerOnCommand' instead.)
windowTimerAttach :: Window a -> IO (Timer ())
windowTimerAttach w
  = do t <- timerCreate w idAny
       windowAddOnDelete w (timerDelete t)
       return t


-- | Create a new 'TimerEx' timer. It is automatically deleted when its owner is deleted
-- (using 'windowAddOnDelete'). React to timer events using 'timerOnCommand'.
windowTimerCreate :: Window a -> IO (TimerEx ())
windowTimerCreate w
  = do t <- timerExCreate
       windowAddOnDelete w (timerDelete t)
       return t

-- | Set an event handler that is called on a timer tick. This works for 'TimerEx'
-- objects.
timerOnCommand :: TimerEx a -> IO () -> IO ()
timerOnCommand timer io
  = do closure <- createClosure io (\ownerDeleted -> return ()) (\ev -> io)
       timerExConnect timer closure

-- | Get the current timer event handler.
timerGetOnCommand :: TimerEx a -> IO (IO ())
timerGetOnCommand timer
  = do closure <- timerExGetClosure timer
       unsafeClosureGetState closure (return ())

------------------------------------------------------------------------------------------
-- Application startup
------------------------------------------------------------------------------------------
-- | Installs an init handler and starts the event loop.
-- Note: the closure is deleted when initialization is complete, and than the Haskell init function
-- is started.
appOnInit :: IO () -> IO ()
appOnInit init
  = do closure  <- createClosure (return () :: IO ()) onDelete (\ev -> return ())   -- run init on destroy !
       progName <- getProgName
       args     <- getArgs
       argv     <- mapM newCString (progName:args)
       let argc = length argv
       withArray (argv ++ [nullPtr]) $ \cargv -> wxcAppInitializeC closure argc cargv
       mapM_ free argv
  where
    onDelete ownerDeleted
      = init


------------------------------------------------------------------------------------------
-- Attaching haskell data to arbitrary objects.
------------------------------------------------------------------------------------------
-- | Use attached haskell data locally. This makes it type-safe.
objectWithClientData :: WxObject a -> b -> ((b -> IO ()) -> IO b -> IO c) -> IO c
objectWithClientData object initx fun
  = do let setter x = objectSetClientData object (return ()) x
           getter   = do mb <- unsafeObjectGetClientData object
                         case mb of
                           Nothing -> return initx
                           Just x  -> return x
       setter initx
       fun setter getter

-- | Attach haskell value to an arbitrary object. The 'IO' action is executed
-- when the object is deleted. Note: 'evtHandlerSetClientData' is preferred when possible.
objectSetClientData :: WxObject a -> IO () -> b -> IO ()
objectSetClientData object onDelete x
  = do closure <- createClosure x (const onDelete) (const (return ()))
       objectSetClientClosure object closure
       return ()

-- | Retrieve an attached haskell value.
unsafeObjectGetClientData :: WxObject a -> IO (Maybe b)
unsafeObjectGetClientData object
  = do closure <- objectGetClientClosure object 
       unsafeClosureGetData closure
                



------------------------------------------------------------------------------------------
-- Generic window connection
------------------------------------------------------------------------------------------
-- | Set a generic event handler on a certain window.
windowOnEvent :: Window a -> [EventId] -> handler -> (Event () -> IO ()) -> IO ()
windowOnEvent window eventIds state eventHandler
  = windowOnEventEx window eventIds state (\ownerDelete -> return ()) eventHandler

-- | Set a generic event handler on a certain window. Takes also a computation
-- that is run when the event handler is destroyed -- the argument is 'True' if the
-- owner is deleted, and 'False' if the event handler is disconnected for example.
windowOnEventEx :: Window a -> [EventId] -> handler -> (Bool -> IO ()) -> (Event () -> IO ()) -> IO ()
windowOnEventEx window eventIds state destroy eventHandler
  = do let id = idAny   -- id <- windowGetId window
       evtHandlerOnEvent window id id eventIds state destroy eventHandler

-- | Retrieve the event handler state for a certain event on a window.
unsafeWindowGetHandlerState :: Window a -> EventId -> b -> IO b
unsafeWindowGetHandlerState window eventId def
  = do id <- windowGetId window
       unsafeGetHandlerState window id eventId def

------------------------------------------------------------------------------------------
-- The current event
------------------------------------------------------------------------------------------
{-# NOINLINE currentEvent #-}
currentEvent :: MVar (Event ())
currentEvent
  = unsafePerformIO (newMVar objectNull)

-- | Get the current event handler (can be 'objectNull').
getCurrentEvent :: IO (Event ())
getCurrentEvent
  = readMVar currentEvent

-- | Do something with the current event /if/ we are calling from an event handler.
withCurrentEvent :: (Event () -> IO ()) -> IO ()
withCurrentEvent f
  = do ev <- getCurrentEvent
       if (ev /= objectNull)
        then f ev
        else return ()

-- | Pass the event on the next /wxWindows/ event handler, either on this window or its parent.
-- Always call this method when you do not process the event.
skipCurrentEvent :: IO ()
skipCurrentEvent
  = withCurrentEvent (\event -> eventSkip event)

------------------------------------------------------------------------------------------
-- Generic event connection
------------------------------------------------------------------------------------------
-- | Retrievs the state associated with a certain event handler. If
-- no event handler is defined for this kind of event or 'Id', the
-- default value is returned.
unsafeGetHandlerState :: EvtHandler a -> Id -> EventId -> b -> IO b
unsafeGetHandlerState object id eventId def
  = do closure <- evtHandlerGetClosure object id eventId
       unsafeClosureGetState closure def

-- | Type synonym to make the type signatures shorter for the documentation :-)
type OnEvent = (Bool -> IO ()) -> (Event () -> IO ()) -> IO ()

-- | Sets a generic event handler, just as 'evtHandlerOnEventConnect' but first
-- disconnects any event handlers for the same kind of events.
evtHandlerOnEvent :: EvtHandler a -> Id -> Id -> [EventId] -> handler -> OnEvent
evtHandlerOnEvent object firstId lastId eventIds state destroy eventHandler
  = do evtHandlerOnEventDisconnect object firstId lastId eventIds
       evtHandlerOnEventConnect object firstId lastId eventIds state destroy eventHandler


-- Hack: using a global variable to determine whether we are disconnecting an event
-- or not. This is used as a parameter to the 'destroy' procedure of an event. This
-- enables us to re-install a 'windowOnDelete' handler for example without executing
-- the deletion code.
{-# NOINLINE disconnecting #-}
disconnecting :: Var Bool
disconnecting
  = unsafePerformIO (varCreate False)

-- | Disconnect a certain event handler.
evtHandlerOnEventDisconnect :: EvtHandler a -> Id -> Id -> [EventId] -> IO ()
evtHandlerOnEventDisconnect object firstId lastId eventIds
  = do prev <- varSwap disconnecting True
       mapM_ disconnectEventId eventIds
       varSet disconnecting prev
  where
    disconnectEventId eventId
      = evtHandlerDisconnect object firstId lastId eventId 0 {- actually: void* -}

-- | Sets a generic event handler on an 'EvtHandler' object. The call
-- (@evtHandlerOnEventConnect firstId lastId eventIds state destroy handler object@) sets an event
-- handler @handler@ on @object@. The eventhandler gets called whenever an event
-- happens that is in the list @eventIds@ on an object with an 'Id' between @firstId@
-- and @lastId@ (use -1 for any object). The @state@ is any kind of haskell data
-- that is attached to this handler. It can be retrieved via 'unsafeGetHandlerState'.
-- Normally, the @state@ is the event handler itself. This allows the current event
-- handler to be retrieved via calls to 'buttonGetOnCommand' for example. The @destroy@
-- action is called when the event handler is destroyed. Its argument is 'True' when the
-- owner is deleted, and 'False' if the event handler is just disconnected.
evtHandlerOnEventConnect :: EvtHandler a -> Id -> Id -> [EventId] -> state -> OnEvent
evtHandlerOnEventConnect object firstId lastId eventIds state destroy eventHandler
  = do closure <- createClosure state destroy eventHandler
       mapM_ (connectEventId closure) eventIds
  where
    connectEventId closure eventId
      = evtHandlerConnect object firstId lastId eventId closure



-- Use a data wrapper for the closure state: seem to circumvent bugs when wrapping
-- things like Int or overloaded stuff.
data Wrap a  = Wrap a


unsafeClosureGetState :: Closure () -> a -> IO a
unsafeClosureGetState closure def
  = do mb <- unsafeClosureGetData closure
       case mb of
         Nothing -> return def
         Just x  -> return x

unsafeClosureGetData :: Closure () -> IO (Maybe a)
unsafeClosureGetData closure
  = if (ptrIsNull closure)
     then return Nothing
     else do ptr <- closureGetData closure
             if (ptrIsNull ptr)
              then return Nothing
              else do (Wrap x) <- deRefStablePtr (castPtrToStablePtr ptr)
                      return (Just x)


-- | Create a closure with a certain haskell state, a function that is called
-- when the closure is destroyed, and a function that is called when an event
-- happens. The destroy function takes a boolean that is 'True' when the parent
-- is deleted (and 'False' when the closure is just disconnected). The event
-- handlers gets the 'Event' as its argument.
createClosure :: state -> (Bool -> IO ()) -> (Event () -> IO ()) -> IO (Closure ())
createClosure st destroy handler
  = do funptr  <- wrapEventHandler eventHandlerWrapper
       stptr   <- newStablePtr (Wrap st)
       closureCreate funptr (castStablePtrToPtr stptr)
  where
    eventHandlerWrapper funptr stptr event
      = do prev <- swapMVar currentEvent event
           if (event==objectNull)
            then do isDisconnecting <- varGet disconnecting
                    destroy (not isDisconnecting)
                    when (stptr/=ptrNull)
                      (freeStablePtr (castPtrToStablePtr stptr))
                    when (funptr/=ptrNull)
                      (freeHaskellFunPtr (castPtrToFunPtr funptr))
            else handler event
           swapMVar currentEvent prev
           return ()



foreign import ccall "wrapper" wrapEventHandler :: (Ptr fun -> Ptr st -> Event () -> IO ()) -> IO (FunPtr (Ptr fun -> Ptr st -> Event () -> IO ()))