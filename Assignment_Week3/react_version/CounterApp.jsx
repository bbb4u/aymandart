import React, { useState, useEffect, useRef, useReducer, createContext, useContext } from 'react';

// ==========================================
// Types & Enums
// ==========================================
export const TimerStatus = {
  STOPPED: 'STOPPED',
  RUNNING: 'RUNNING',
  PAUSED: 'PAUSED',
};

// ==========================================
// 1. VERSION A: REACT CONTEXT + USEREDUCER
// ==========================================
const initialState = {
  counter: 0,
  timerStatus: TimerStatus.STOPPED,
  secondsElapsed: 0,
  lifecycleLogs: [],
};

function counterReducer(state, action) {
  const time = new Date().toLocaleTimeString();
  switch (action.type) {
    case 'INCREMENT':
      return {
        ...state,
        counter: state.counter + 1,
        lifecycleLogs: [`[${time}] زيادة العداد: ${state.counter + 1}`, ...state.lifecycleLogs],
      };
    case 'DECREMENT':
      return {
        ...state,
        counter: Math.max(0, state.counter - 1),
        lifecycleLogs: [`[${time}] إنقاص العداد: ${Math.max(0, state.counter - 1)}`, ...state.lifecycleLogs],
      };
    case 'RESET':
      return {
        ...state,
        counter: 0,
        lifecycleLogs: [`[${time}] تصفير العداد إلى 0`, ...state.lifecycleLogs],
      };
    case 'TICK':
      return {
        ...state,
        secondsElapsed: state.secondsElapsed + 1,
        counter: state.counter + 1,
      };
    case 'SET_STATUS':
      return {
        ...state,
        timerStatus: action.status,
        lifecycleLogs: [`[${time}] [المؤقت] تغيرت الحالة إلى: ${action.status}`, ...state.lifecycleLogs],
      };
    case 'STOP_TIMER':
      return {
        ...state,
        timerStatus: TimerStatus.STOPPED,
        secondsElapsed: 0,
        lifecycleLogs: [`[${time}] [المؤقت] إيقاف كلي وإعادة ضبط المؤقت`, ...state.lifecycleLogs],
      };
    case 'ADD_LOG':
      return {
        ...state,
        lifecycleLogs: [`[${time}] ${action.log}`, ...state.lifecycleLogs],
      };
    case 'CLEAR_LOGS':
      return {
        ...state,
        lifecycleLogs: [],
      };
    default:
      return state;
  }
}

const ContextCounterContext = createContext(null);

export function ContextCounterProvider({ children }) {
  const [state, dispatch] = useReducer(counterReducer, initialState);
  const timerRef = useRef(null);

  // دورة حياة المكون والتنظيف (Lifecycle mount & unmount cleanup)
  useEffect(() => {
    dispatch({ type: 'ADD_LOG', log: '[React Lifecycle] تم تحميل المزود (Provider Mounted)' });

    // تتبع حالة الصفحة (App / Tab Visibility)
    const handleVisibilityChange = () => {
      dispatch({
        type: 'ADD_LOG',
        log: `[Visibility Lifecycle] حالة الصفحة: ${document.visibilityState}`,
      });
    };
    document.addEventListener('visibilitychange', handleVisibilityChange);

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
      document.removeEventListener('visibilitychange', handleVisibilityChange);
      console.log('[React Lifecycle] تم إلغاء المزود وتنظيف الموارد (Unmounted & Disposed)');
    };
  }, []);

  // إدارة المؤقت حسب الحالة
  useEffect(() => {
    if (state.timerStatus === TimerStatus.RUNNING) {
      timerRef.current = setInterval(() => {
        dispatch({ type: 'TICK' });
      }, 1000);
    } else {
      if (timerRef.current) clearInterval(timerRef.current);
    }

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [state.timerStatus]);

  const actions = {
    increment: () => dispatch({ type: 'INCREMENT' }),
    decrement: () => dispatch({ type: 'DECREMENT' }),
    reset: () => dispatch({ type: 'RESET' }),
    startTimer: () => dispatch({ type: 'SET_STATUS', status: TimerStatus.RUNNING }),
    pauseTimer: () => dispatch({ type: 'SET_STATUS', status: TimerStatus.PAUSED }),
    resumeTimer: () => dispatch({ type: 'SET_STATUS', status: TimerStatus.RUNNING }),
    stopTimer: () => dispatch({ type: 'STOP_TIMER' }),
    clearLogs: () => dispatch({ type: 'CLEAR_LOGS' }),
  };

  return (
    <ContextCounterContext.Provider value={{ state, actions }}>
      {children}
    </ContextCounterContext.Provider>
  );
}

// شاشة العرض لنسخة Context API
export function CounterScreenContext() {
  const { state, actions } = useContext(ContextCounterContext);

  return (
    <div style={cardStyle}>
      <div style={{ ...badgeStyle, backgroundColor: '#ede7f6', color: '#512da8' }}>
        ⚡ إدارة الحالة: React Context API + useReducer
      </div>
      <h2 style={{ color: '#512da8' }}>العداد التفاعلي (Context Version)</h2>
      <div style={counterNumberStyle}>{state.counter}</div>

      <div style={buttonRowStyle}>
        <button onClick={actions.decrement} style={{ ...buttonStyle, background: '#d32f2f' }}>
          - إنقاص
        </button>
        <button onClick={actions.reset} style={{ ...buttonStyle, background: '#757575' }}>
          🔄 تصفير
        </button>
        <button onClick={actions.increment} style={{ ...buttonStyle, background: '#388e3c' }}>
          + زيادة
        </button>
      </div>

      <div style={timerBoxStyle}>
        <h3>المؤقت التلقائي</h3>
        <p>الوقت المنقضي: <b>{state.secondsElapsed}</b> ثانية | الحالة: <b>{state.timerStatus}</b></p>
        <div style={buttonRowStyle}>
          <button
            onClick={actions.startTimer}
            disabled={state.timerStatus === TimerStatus.RUNNING}
            style={buttonStyle}
          >
            بدء (Start)
          </button>
          <button
            onClick={actions.pauseTimer}
            disabled={state.timerStatus !== TimerStatus.RUNNING}
            style={{ ...buttonStyle, background: '#f57c00' }}
          >
            إيقاف مؤقت (Pause)
          </button>
          <button
            onClick={actions.resumeTimer}
            disabled={state.timerStatus !== TimerStatus.PAUSED}
            style={{ ...buttonStyle, background: '#1976d2' }}
          >
            استئناف (Resume)
          </button>
          <button
            onClick={actions.stopTimer}
            disabled={state.timerStatus === TimerStatus.STOPPED}
            style={{ ...buttonStyle, background: '#d32f2f' }}
          >
            إيقاف كامل (Stop)
          </button>
        </div>
      </div>

      <div style={logBoxStyle}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h4>سجل تحليل دورة الحياة (Lifecycle Audit)</h4>
          <button onClick={actions.clearLogs} style={{ padding: '4px 8px', fontSize: 12 }}>مسح</button>
        </div>
        <div style={logListStyle}>
          {state.lifecycleLogs.map((log, i) => (
            <div key={i} style={logItemStyle}>{log}</div>
          ))}
        </div>
      </div>
    </div>
  );
}

// Styles
const cardStyle = {
  border: '1px solid #ddd',
  borderRadius: 12,
  padding: 20,
  maxWidth: 550,
  margin: '10px auto',
  fontFamily: 'system-ui, sans-serif',
  boxShadow: '0 4px 12px rgba(0,0,0,0.08)',
  direction: 'rtl',
  textAlign: 'center',
};
const badgeStyle = {
  padding: '6px 12px',
  borderRadius: 6,
  fontWeight: 'bold',
  fontSize: 14,
  marginBottom: 10,
};
const counterNumberStyle = {
  fontSize: 56,
  fontWeight: 'bold',
  margin: '15px 0',
};
const buttonRowStyle = {
  display: 'flex',
  justifyContent: 'center',
  gap: 10,
  flexWrap: 'wrap',
  margin: '12px 0',
};
const buttonStyle = {
  padding: '8px 16px',
  fontSize: 14,
  fontWeight: 'bold',
  color: '#fff',
  background: '#1976d2',
  border: 'none',
  borderRadius: 6,
  cursor: 'pointer',
};
const timerBoxStyle = {
  background: '#f9f9f9',
  padding: 15,
  borderRadius: 8,
  margin: '15px 0',
};
const logBoxStyle = {
  textAlign: 'right',
  marginTop: 15,
};
const logListStyle = {
  height: 120,
  overflowY: 'auto',
  background: '#263238',
  color: '#80cbc4',
  padding: 10,
  borderRadius: 6,
  fontSize: 12,
  fontFamily: 'monospace',
};
const logItemStyle = {
  padding: '2px 0',
  borderBottom: '1px solid #37474f',
};
