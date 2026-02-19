package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// =============================================================================
// Catppuccin Mocha colors
// =============================================================================

var (
	green  = lipgloss.Color("#a6e3a1")
	red    = lipgloss.Color("#f38ba8")
	yellow = lipgloss.Color("#f9e2af")
	blue   = lipgloss.Color("#89b4fa")
	mauve  = lipgloss.Color("#cba6f7")
	dim    = lipgloss.Color("#6c7086")
	sub    = lipgloss.Color("#a6adc8")

	greenStyle  = lipgloss.NewStyle().Foreground(green)
	redStyle    = lipgloss.NewStyle().Foreground(red)
	yellowStyle = lipgloss.NewStyle().Foreground(yellow)
	blueStyle   = lipgloss.NewStyle().Foreground(blue)
	mauveStyle  = lipgloss.NewStyle().Foreground(mauve)
	dimStyle    = lipgloss.NewStyle().Foreground(dim)
	subStyle    = lipgloss.NewStyle().Foreground(sub)
	boldMauve   = lipgloss.NewStyle().Foreground(mauve).Bold(true)
)

// =============================================================================
// Target definitions
// =============================================================================

type target struct {
	name    string
	src     string // relative to script dir
	dest    string // relative to $HOME (or absolute)
	isDir   bool
	command string // command to check if app is installed
	special string // "zshenv" for special handling
}

func allTargets() []target {
	home := os.Getenv("HOME")
	return []target{
		{name: "zsh", src: "zshrc", dest: filepath.Join(home, ".zshrc"), command: "zsh"},
		{name: "nvim", src: "nvim", dest: filepath.Join(home, ".config", "nvim"), isDir: true, command: "nvim"},
		{name: "tmux", src: "tmux.conf", dest: filepath.Join(home, ".config", "tmux", "tmux.conf"), command: "tmux"},
		{name: "aerospace", src: "aerospace.toml", dest: filepath.Join(home, ".aerospace.toml"), command: "aerospace"},
		{name: "ghostty", src: "config.ghostty", dest: filepath.Join(home, ".config", "ghostty", "config")},
		{name: "git", src: "gitconfig", dest: filepath.Join(home, ".gitconfig"), command: "git"},
		{name: "vscode", src: "vscode-settings-user.json", dest: filepath.Join(home, "Library", "Application Support", "Code", "User", "settings.json")},
		{name: "zshenv", src: "zshenv.example", dest: filepath.Join(home, ".zshenv"), special: "zshenv"},
	}
}

// =============================================================================
// Bubble Tea model
// =============================================================================

type phase int

const (
	phaseSelect phase = iota
	phaseConfirm
	phaseDeploy
	phaseDone
)

type model struct {
	targets  []target
	selected []bool
	cursor   int
	phase    phase

	// deploy results
	deployed int
	skipped  int
	failed   int
	results  []string

	// config
	scriptDir string
	backupDir string
	doBackup  bool
}

func initialModel(scriptDir string) model {
	targets := allTargets()
	selected := make([]bool, len(targets))
	return model{
		targets:   targets,
		selected:  selected,
		cursor:    0,
		phase:     phaseSelect,
		scriptDir: scriptDir,
		backupDir: filepath.Join(os.Getenv("HOME"), ".dotfiles-backup", time.Now().Format("2006-01-02_150405")),
		doBackup:  true,
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch m.phase {
		case phaseSelect:
			return m.updateSelect(msg)
		case phaseConfirm:
			return m.updateConfirm(msg)
		case phaseDeploy, phaseDone:
			return m.updateDone(msg)
		}
	}
	return m, nil
}

func (m model) updateSelect(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "q", "ctrl+c":
		return m, tea.Quit

	case "up", "k":
		if m.cursor > 0 {
			m.cursor--
		}

	case "down", "j":
		if m.cursor < len(m.targets)-1 {
			m.cursor++
		}

	case " ":
		m.selected[m.cursor] = !m.selected[m.cursor]

	case "a":
		allSelected := true
		for _, s := range m.selected {
			if !s {
				allSelected = false
				break
			}
		}
		for i := range m.selected {
			m.selected[i] = !allSelected
		}

	case "enter":
		// check if any selected
		anySelected := false
		for _, s := range m.selected {
			if s {
				anySelected = true
				break
			}
		}
		if anySelected {
			m.phase = phaseConfirm
		}
	}
	return m, nil
}

func (m model) updateConfirm(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "q", "ctrl+c", "n":
		m.phase = phaseSelect
		return m, nil

	case "y", "enter":
		m.phase = phaseDeploy
		m.runDeploy()
		m.phase = phaseDone
		return m, nil

	case "b":
		m.doBackup = !m.doBackup
		return m, nil
	}
	return m, nil
}

func (m model) updateDone(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "q", "ctrl+c", "enter":
		return m, tea.Quit
	}
	return m, nil
}

// =============================================================================
// View
// =============================================================================

func (m model) View() string {
	var b strings.Builder

	b.WriteString("\n")
	b.WriteString(boldMauve.Render("  terminal-setup deploy"))
	b.WriteString("\n")
	b.WriteString(dimStyle.Render("  ─────────────────────────"))
	b.WriteString("\n\n")

	switch m.phase {
	case phaseSelect:
		m.viewSelect(&b)
	case phaseConfirm:
		m.viewConfirm(&b)
	case phaseDeploy:
		b.WriteString(dimStyle.Render("  deploying..."))
		b.WriteString("\n")
	case phaseDone:
		m.viewDone(&b)
	}

	return b.String()
}

func (m model) viewSelect(b *strings.Builder) {
	b.WriteString(subStyle.Render("  select configs to deploy:"))
	b.WriteString("\n\n")

	for i, t := range m.targets {
		cursor := "  "
		if i == m.cursor {
			cursor = mauveStyle.Render("> ")
		}

		checked := dimStyle.Render("[ ]")
		if m.selected[i] {
			checked = greenStyle.Render("[x]")
		}

		name := dimStyle.Render(t.name)
		if m.selected[i] {
			name = mauveStyle.Render(t.name)
		}
		if i == m.cursor {
			name = lipgloss.NewStyle().Foreground(mauve).Bold(true).Render(t.name)
		}

		arrow := dimStyle.Render(fmt.Sprintf("%-16s", t.src)) + blueStyle.Render(" -> ") + dimStyle.Render(shortPath(t.dest))

		b.WriteString(fmt.Sprintf("  %s%s %-12s %s\n", cursor, checked, name, arrow))
	}

	b.WriteString("\n")
	b.WriteString(dimStyle.Render("  space") + subStyle.Render(" toggle  "))
	b.WriteString(dimStyle.Render("a") + subStyle.Render(" all  "))
	b.WriteString(dimStyle.Render("enter") + subStyle.Render(" deploy  "))
	b.WriteString(dimStyle.Render("q") + subStyle.Render(" quit"))
	b.WriteString("\n\n")
}

func (m model) viewConfirm(b *strings.Builder) {
	b.WriteString(subStyle.Render("  deploy these configs?"))
	b.WriteString("\n\n")

	for i, t := range m.targets {
		if m.selected[i] {
			b.WriteString(fmt.Sprintf("    %s %s\n", mauveStyle.Render("*"), mauveStyle.Render(t.name)))
		}
	}

	b.WriteString("\n")
	backupStatus := greenStyle.Render("on")
	if !m.doBackup {
		backupStatus = yellowStyle.Render("off")
	}
	b.WriteString(fmt.Sprintf("  %s backup: %s\n", subStyle.Render("  "), backupStatus))
	b.WriteString("\n")
	b.WriteString(dimStyle.Render("  y/enter") + subStyle.Render(" confirm  "))
	b.WriteString(dimStyle.Render("b") + subStyle.Render(" toggle backup  "))
	b.WriteString(dimStyle.Render("n") + subStyle.Render(" back"))
	b.WriteString("\n\n")
}

func (m model) viewDone(b *strings.Builder) {
	for _, r := range m.results {
		b.WriteString(r)
		b.WriteString("\n")
	}

	b.WriteString("\n")
	b.WriteString(dimStyle.Render("  ─────────────────────────"))
	b.WriteString("\n")

	parts := fmt.Sprintf("  %s", greenStyle.Render(fmt.Sprintf("%d deployed", m.deployed)))
	if m.skipped > 0 {
		parts += dimStyle.Render(" . ") + yellowStyle.Render(fmt.Sprintf("%d skipped", m.skipped))
	}
	if m.failed > 0 {
		parts += dimStyle.Render(" . ") + redStyle.Render(fmt.Sprintf("%d failed", m.failed))
	}
	b.WriteString(parts)
	b.WriteString("\n\n")

	b.WriteString(subStyle.Render("  reload tips:"))
	b.WriteString("\n")
	b.WriteString(subStyle.Render("    zsh        ") + dimStyle.Render("source ~/.zshrc"))
	b.WriteString("\n")
	b.WriteString(subStyle.Render("    tmux       ") + dimStyle.Render("Ctrl-a + I"))
	b.WriteString("\n")
	b.WriteString(subStyle.Render("    aerospace  ") + dimStyle.Render("alt-shift-; then esc"))
	b.WriteString("\n\n")

	b.WriteString(dimStyle.Render("  press enter or q to exit"))
	b.WriteString("\n\n")
}

// =============================================================================
// Deploy logic
// =============================================================================

func (m *model) runDeploy() {
	selected := m.selectedTargets()

	// Check apps
	for _, t := range selected {
		if t.command != "" {
			if !commandExists(t.command) {
				m.results = append(m.results, fmt.Sprintf("  %s %-10s %s",
					yellowStyle.Render("[!]"),
					dimStyle.Render(t.command),
					dimStyle.Render("not found, config will be deployed anyway"),
				))
			}
		}
	}

	// Backup
	if m.doBackup {
		backed := m.backupTargets(selected)
		if backed {
			m.results = append(m.results, "")
		}
	}

	// Deploy
	for _, t := range selected {
		m.deployTarget(t)
	}
}

func (m *model) backupTargets(targets []target) bool {
	anyBacked := false
	for _, t := range targets {
		if t.special == "zshenv" {
			continue
		}
		if fileExists(t.dest) {
			if !anyBacked {
				m.results = append(m.results, fmt.Sprintf("  %s %s",
					subStyle.Render("backing up to"),
					dimStyle.Render(m.backupDir+"/"),
				))
				anyBacked = true
			}
			if err := backupPath(t.dest, m.backupDir); err != nil {
				m.results = append(m.results, fmt.Sprintf("    %s %s",
					dimStyle.Render("->"),
					redStyle.Render(fmt.Sprintf("failed to backup %s: %v", t.dest, err)),
				))
			} else {
				m.results = append(m.results, fmt.Sprintf("    %s %s",
					dimStyle.Render("->"),
					dimStyle.Render(t.dest),
				))
			}
		}
	}
	return anyBacked
}

func (m *model) deployTarget(t target) {
	src := filepath.Join(m.scriptDir, t.src)

	// Special handling for zshenv
	if t.special == "zshenv" {
		if fileExists(t.dest) {
			m.results = append(m.results, fmt.Sprintf("  %s %s %s",
				yellowStyle.Render("[~]"),
				mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
				yellowStyle.Render("skipped ($HOME/.zshenv already exists)"),
			))
			m.skipped++
			return
		}
		if err := copyFile(src, t.dest); err != nil {
			m.results = append(m.results, fmt.Sprintf("  %s %s %s",
				redStyle.Render("[x]"),
				mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
				redStyle.Render("failed to copy zshenv.example"),
			))
			m.failed++
			return
		}
		_ = os.Chmod(t.dest, 0600)
		m.results = append(m.results, fmt.Sprintf("  %s %s %s %s %s",
			greenStyle.Render("[+]"),
			mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
			subStyle.Render(t.src),
			blueStyle.Render("->"),
			subStyle.Render(t.dest),
		))
		m.results = append(m.results, fmt.Sprintf("    %s",
			yellowStyle.Render("fill in your tokens and keep chmod 600"),
		))
		m.deployed++
		return
	}

	// Ensure dest parent dir exists
	destDir := filepath.Dir(t.dest)
	if err := os.MkdirAll(destDir, 0755); err != nil {
		m.results = append(m.results, fmt.Sprintf("  %s %s %s",
			redStyle.Render("[x]"),
			mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
			redStyle.Render(fmt.Sprintf("failed to create %s", destDir)),
		))
		m.failed++
		return
	}

	var err error
	if t.isDir {
		err = copyDir(src, t.dest)
	} else {
		err = copyFile(src, t.dest)
	}

	if err != nil {
		m.results = append(m.results, fmt.Sprintf("  %s %s %s",
			redStyle.Render("[x]"),
			mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
			redStyle.Render(fmt.Sprintf("failed to copy %s", t.src)),
		))
		m.failed++
		return
	}

	destDisplay := shortPath(t.dest)
	srcDisplay := t.src
	if t.isDir {
		srcDisplay += "/"
		destDisplay += "/"
	}

	m.results = append(m.results, fmt.Sprintf("  %s %s %s %s %s",
		greenStyle.Render("[+]"),
		mauveStyle.Render(fmt.Sprintf("%-10s", t.name)),
		subStyle.Render(srcDisplay),
		blueStyle.Render("->"),
		subStyle.Render(destDisplay),
	))
	m.deployed++
}

func (m model) selectedTargets() []target {
	var result []target
	for i, t := range m.targets {
		if m.selected[i] {
			result = append(result, t)
		}
	}
	return result
}

// =============================================================================
// Helpers
// =============================================================================

func shortPath(p string) string {
	home := os.Getenv("HOME")
	if strings.HasPrefix(p, home) {
		return "~" + p[len(home):]
	}
	return p
}

func commandExists(cmd string) bool {
	for _, dir := range filepath.SplitList(os.Getenv("PATH")) {
		if fileExists(filepath.Join(dir, cmd)) {
			return true
		}
	}
	return false
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func backupPath(src, backupDir string) error {
	if err := os.MkdirAll(backupDir, 0755); err != nil {
		return err
	}
	base := filepath.Base(src)
	dest := filepath.Join(backupDir, base)
	return copyAny(src, dest)
}

func copyAny(src, dest string) error {
	info, err := os.Stat(src)
	if err != nil {
		return err
	}
	if info.IsDir() {
		return copyDir(src, dest)
	}
	return copyFile(src, dest)
}

func copyFile(src, dest string) error {
	data, err := os.ReadFile(src)
	if err != nil {
		return err
	}
	return os.WriteFile(dest, data, 0644)
}

func copyDir(src, dest string) error {
	// Remove destination first to ensure clean copy
	if err := os.RemoveAll(dest); err != nil {
		return err
	}
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		destPath := filepath.Join(dest, rel)

		if info.IsDir() {
			return os.MkdirAll(destPath, info.Mode())
		}
		return copyFile(path, destPath)
	})
}

// =============================================================================
// Main
// =============================================================================

func main() {
	// Find script dir (where the repo configs live)
	exe, err := os.Executable()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	scriptDir := filepath.Dir(exe)

	// If running via `go run`, use current working directory
	if strings.Contains(exe, "go-build") || strings.Contains(exe, "/tmp/") {
		scriptDir, _ = os.Getwd()
	}

	// Allow override via env
	if envDir := os.Getenv("DOTFILES_DIR"); envDir != "" {
		scriptDir = envDir
	}

	m := initialModel(scriptDir)

	p := tea.NewProgram(m)
	finalModel, err := p.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}

	if fm, ok := finalModel.(model); ok && fm.failed > 0 {
		os.Exit(1)
	}
}
