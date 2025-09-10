<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class RedirectByRole
{
    /**
     * Redireciona usuários autenticados para o "painel" correto
     * quando tentam acessar rotas não permitidas para seu papel.
     */
    public function handle(Request $request, Closure $next)
    {
        // ✅ NUNCA interfere em rotas de API
        if ($request->is('api/*')) {
            return $next($request);
        }

        // Só controla navegação GET e se houver usuário autenticado
        if (!$request->isMethod('GET') || !$request->user()) {
            return $next($request);
        }

        $user    = $request->user();
        $current = optional($request->route())->getName(); // nome da rota (se existir)
        $path    = trim($request->path(), '/');            // fallback pelo caminho

        // Se o usuário tiver múltiplos papéis, esta é a prioridade
        $priority = ['admin', 'analista', 'tesoureiro', 'agente', 'associado'];

        $role = null;
        foreach ($priority as $r) {
            if ($user->hasRole($r)) { $role = $r; break; }
        }
        if (!$role) {
            // sem papel conhecido → não redireciona
            return $next($request);
        }

        // Mapa de rotas permitidas por papel
        $map = [
            'admin' => [
                'default'     => 'admin.dashboardadmin',
                'allowed'     => ['admin.dashboardadmin'],
                'name_prefix' => 'admin.',   // libera qualquer rota nomeada que comece com "admin."
                'path_prefix' => 'admin',    // e qualquer path que comece com "admin"
            ],
            'analista' => [
                'default'     => 'analista.dashboardanalista',
                'allowed'     => ['analista.dashboardanalista'],
                'name_prefix' => 'analista.',
                'path_prefix' => 'analista',
            ],
            'tesoureiro' => [
                'default'     => 'tesoureiro.dashboardtesoureiro',
                'allowed'     => ['tesoureiro.dashboardtesoureiro'],
                'name_prefix' => 'tesoureiro.',
                'path_prefix' => 'tesoureiro',
            ],
            'agente' => [
                'default'     => 'agente.dashboardagente',
                'allowed'     => ['agente.dashboardagente'],
                'name_prefix' => 'agente.',
                'path_prefix' => 'agente',
            ],
            'associado' => [
                'default'     => 'associado.dashboardassociado',
                'allowed'     => ['associado.dashboardassociado'],
                'name_prefix' => 'associado.',
                'path_prefix' => 'associado',
            ],
        ];

        $cfg = $map[$role];

        // Se a rota tem nome, priorize checagem por prefixo do nome
        if ($current) {
            if (
                (!empty($cfg['name_prefix']) && Str::startsWith($current, $cfg['name_prefix'])) ||
                (!empty($cfg['allowed']) && in_array($current, $cfg['allowed'], true))
            ) {
                return $next($request);
            }
            return redirect()->route($cfg['default']);
        }

        // Se não tem nome, cheque prefixo do path
        if (
            (!empty($cfg['path_prefix']) && Str::startsWith($path, $cfg['path_prefix'])) ||
            (!empty($cfg['allowedPaths'] ?? []) && in_array($path, $cfg['allowedPaths'], true))
        ) {
            return $next($request);
        }

        return redirect()->route($cfg['default']);
    }
}
