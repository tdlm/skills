# Stateful Compound Components

Use this pattern for components that need shared state across sibling sub-components (e.g., form state, selection, open/close).

## Anti-Patterns

### Bad: State Trapped Inside Component

```tsx
function ComposerForm() {
  let [state, setState] = useState(initialState)
  return <Composer.Frame><Composer.Input /></Composer.Frame>
}

// Problem: How does ForwardButton access composer state?
function ForwardMessageDialog() {
  return (
    <div>
      <ComposerForm />
      <MessagePreview />   {/* Can't access state */}
      <ForwardButton />    {/* Can't call submit */}
    </div>
  )
}
```

### Bad: useEffect to Sync State Up

```tsx
function ForwardMessageDialog() {
  const [input, setInput] = useState('')
  return <ComposerForm onInputChange={setInput} />
}

function ComposerForm({ onInputChange }) {
  const [state, setState] = useState(initialState)
  useEffect(() => { onInputChange(state.input) }, [state.input, onInputChange]) // Messy sync loop
}
```

## Good: Lift State into Provider

### Context and Hook

```tsx
interface ComposerState {
  input: string
  attachments: Attachment[]
  isSubmitting: boolean
}

interface ComposerActions {
  update: (updater: (state: ComposerState) => ComposerState) => void
  submit: () => void
}

interface ComposerMeta {
  inputRef: React.RefObject<HTMLInputElement>
}

interface ComposerContextValue {
  state: ComposerState
  actions: ComposerActions
  meta: ComposerMeta
}

const ComposerContext = createContext<ComposerContextValue | null>(null)

function useComposer() {
  const ctx = useContext(ComposerContext)
  if (!ctx) throw new Error('Must be used within Composer.Provider')
  return ctx
}
```

### Provider as Thin Context Conduit

The Provider accepts `state`, `actions`, and `meta` as props -- it does NOT manage state itself. This decouples UI from state implementation:

```tsx
function ComposerProvider({ children, state, actions, meta }: ComposerContextValue & { children: ReactNode }) {
  return (
    <ComposerContext.Provider value={{ state, actions, meta }}>
      {children}
    </ComposerContext.Provider>
  )
}

// Export as namespace (consistent with Object.assign pattern)
const Composer = {
  Provider: ComposerProvider,
  Frame: ComposerFrame,
  Input: ComposerInput,
  Submit: ComposerSubmit,
}

export { Composer }
```

### Specific Implementations Manage State

Different providers manage state differently but pass it through `Composer.Provider`:

```tsx
// Local state for ephemeral forms
function ForwardMessageProvider({ children }: { children: ReactNode }) {
  let [state, setState] = useState(initialState)
  let forwardMessage = useForwardMessage()
  let inputRef = useRef<HTMLInputElement>(null)

  return (
    <Composer.Provider
      state={state}
      actions={{ update: setState, submit: forwardMessage }}
      meta={{ inputRef }}
    >
      {children}
    </Composer.Provider>
  )
}

// Global synced state for channels
function ChannelProvider({ channelId, children }: { channelId: string; children: ReactNode }) {
  const { state, update, submit } = useGlobalChannel(channelId)

  return (
    <Composer.Provider state={state} actions={{ update, submit }} meta={{ inputRef: useRef(null) }}>
      {children}
    </Composer.Provider>
  )
}

// Same Composer.Input works with both!
<ForwardMessageProvider><Composer.Input /></ForwardMessageProvider>
<ChannelProvider channelId={id}><Composer.Input /></ChannelProvider>
```

## Components Outside the Frame

Components inside the Provider can access state regardless of visual nesting:

```tsx
function ForwardMessageDialog() {
  return (
    <ForwardMessageProvider>
      <Composer.Frame>
        <Composer.Input />
      </Composer.Frame>

      {/* These are OUTSIDE the frame but INSIDE the provider -- they work */}
      <MessagePreview />
      <ForwardButton />
    </ForwardMessageProvider>
  )
}

function ForwardButton() {
  const { actions } = useComposer()
  return <Button onClick={actions.submit}>Forward</Button>
}

function MessagePreview() {
  const { state } = useComposer()
  return <Preview input={state.input} />
}
```

## Rules

1. State management lives in specific provider implementations, not in UI components or `Composer.Provider`
2. `Composer.Provider` is a thin context conduit -- accepts `state`, `actions`, `meta` as props
3. UI components only know about the context interface (`useComposer()`)
4. Different providers can implement the same interface differently (local state, global state, etc.)
5. Provider boundary determines access, not visual nesting
